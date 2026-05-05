import Foundation
import StoreKit

@MainActor
@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isPro: Bool = false

    private var _transactionListener: Task<Void, Never>?

    static let monthlyID = "com.zzoutuo.PipelyCRM.monthly"
    static let yearlyID = "com.zzoutuo.PipelyCRM.yearly"

    init() {
        _transactionListener = Task {
            for await result in Transaction.updates {
                do {
                    let transaction = try Self.checkVerified(result)
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    func stopListening() {
        _transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: [Self.monthlyID, Self.yearlyID])
            products = storeProducts
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async -> StoreKit.Transaction? {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try Self.checkVerified(verification)
                await updatePurchasedProducts()
                await transaction.finish()
                return transaction
            case .userCancelled, .pending:
                return nil
            @unknown default:
                return nil
            }
        } catch {
            print("Purchase failed: \(error)")
            return nil
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            print("Restore failed: \(error)")
        }
    }

    var monthlyProduct: Product? {
        products.first { $0.id == Self.monthlyID }
    }

    var yearlyProduct: Product? {
        products.first { $0.id == Self.yearlyID }
    }

    private func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try Self.checkVerified(result)
                purchasedIDs.insert(transaction.productID)
            } catch {
                print("Failed to verify transaction: \(error)")
            }
        }
        purchasedProductIDs = purchasedIDs
        isPro = purchasedProductIDs.contains(Self.monthlyID) || purchasedProductIDs.contains(Self.yearlyID)
    }

    private static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
