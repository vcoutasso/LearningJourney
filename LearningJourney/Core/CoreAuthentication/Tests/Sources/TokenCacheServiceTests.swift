import XCTest
import Security

@testable import CoreAuthentication

final class TokenCacheServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    private let keychainMock = KeychainManagerMock()
    private lazy var sut = TokenCacheService(keychainManager: keychainMock)
    
    // MARK: - Unit tests
    
    func test_token_whenCacheIsEmpty_itShouldReturnNil() {
        // Given / When
        let token = sut.token
        
        // Then
        XCTAssertNil(token)
    }
    
    func test_token_whenCached_itShouldReturnData() throws {
        // Given
        keychainMock.dataToCopy = try .tokenFixture()
        
        // When
        let token = sut.token
        
        // Then
        XCTAssertNotNil(token)
    }
    
    func test_cache_itShouldDeleteCurrentItem_andAddNewItem() throws {
        // Given
        let dummyData: Data = try .tokenFixture()
        
        // When
        sut.cache(token: dummyData)
        
        // Then
        XCTAssertEqual(keychainMock.addCallCount, 1)
        XCTAssertEqual(keychainMock.deleteCallCount, 1)
        
    }
}

final class KeychainManagerMock: KeychainManaging {
    
    // MARK: - Properties

    private(set) var addCallCount = 0
    private(set) var deleteCallCount = 0
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Leychain managing
    var add: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus { _add }
    var copy: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus { _copy }
    var delete: (CFDictionary) -> OSStatus { _delete }
    var dataToCopy: Data?
    
    // MARK: - Helpers
    private func _add(_ dict: CFDictionary, res: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        addCallCount += 1
        return noErr
    }
    
    private func _copy(_ dict: CFDictionary, res: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        res?.pointee = dataToCopy as CFTypeRef?
        return noErr
    }
    
    private func _delete(_ dict: CFDictionary) -> OSStatus {
        deleteCallCount += 1
        return noErr
    }
    
    
}
