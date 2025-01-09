//
//  MarksViewModelUnitTests.swift
//  MarksViewModelUnitTests
//
//  Created by Marcin Wawer on 24-12-2024.
//

import Testing
import Foundation
@testable import UniversityOrganizer

struct MarksViewModelUnitTests {
    
    private let viewModel = MarksViewModel(marks: [])
    
    @Test
    func isMarkValid_pointsGotGreaterThanPointsMax() async throws {
        let (isValid, message) = viewModel.isMarkValid(pointsGot: 15, pointsMax: 10)
        #expect(!isValid, "Expected false, when pointsGot > pointsMax.")
        #expect(message == "Number of points you got cannot be higher than maximum points!")
    }
    
    @Test
    func isMarkValid_pointsMaxEqualsZero() async throws {
        let (isValid, message) = viewModel.isMarkValid(pointsGot: 0, pointsMax: 0)
        #expect(!isValid, "Expected false, when pointsMax == 0.")
        #expect(message == "Maximum number of points cannot be zero!")
    }
    
    @Test
    func isMarkValid_validValues() async throws {
        let (isValid, message) = viewModel.isMarkValid(pointsGot: 5, pointsMax: 10)
        #expect(isValid, "Expected true, when pointsGot <= pointsMax and pointsMax != 0.")
        #expect(message == nil, "Expected no communicate when data is valid.")
    }
    
    @Test
    func formatPoints_roundsToTwoDecimalPlaces() async throws {
        let result = viewModel.formatPoints(12.34567)
        #expect(result == "12.35", "Number should be formmated to two decimal places.")
    }
    
    @Test
    func formatPoints_removesTrailingZeros() async throws {
        let result = viewModel.formatPoints(10.0)
        #expect(result == "10", "Trailing zeros should be removed")
    }
    
    @Test
    func formatPoints_removesOnlyUnnecessaryZeros() async throws {
        let result = viewModel.formatPoints(10.50)
        #expect(result == "10.5", "Only unnecessary zeros should be removed, for example '.50' → '.5'.")
    }
    
    @Test
    func formatDate_correctFormat() async throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let testDate = formatter.date(from: "2024-12-24") else {
            Issue.record("Cannot create test date")
            return
        }
        
        let formatted = viewModel.formatDate(testDate)
        #expect(formatted == "24 Dec 2024", "Expected format: dd MMM yyyy, np. 24 Dec 2024.")
    }
    
    @Test
    func getDoubleValue_stringWithDot() async throws {
        let result = viewModel.getDoubleValue("3.14")
        #expect(result == 3.14, "'3.14' should be converted to 3.13 (Double).")
    }
    
    @Test
    func getDoubleValue_stringWithComma() async throws {
        let result = viewModel.getDoubleValue("2,5")
        #expect(result == 2.5, "Should change comma to period and return 2.5 (Double).")
    }
    
    @Test
    func getDoubleValue_invalidString() async throws {
        let result = viewModel.getDoubleValue("abc")
        #expect(result == 0, "Should return 0, beacular 'abc' is not a valid Double.")
    }
    
    @Test
    func averageMarks_emptyArray() async throws {
        let marks: [Mark] = []
        let result = MarksViewModel.averageMarks(marks: marks)
        #expect(result == 0.0, "Should return 0.0 for empty array")
    }
    
    @Test
    func averageMarks_correctValues() async throws {
        let someSubject = Subject(name: "Test Subject", type: .lecture)
        
        let marks = [
            Mark(pointsGot: 25, pointsMax: 50, subject: someSubject), // 25/50 = 0.5 → 50%
            Mark(pointsGot: 20, pointsMax: 20, subject: someSubject), // 20/20 = 1.0 → 100%
            Mark(pointsGot: 8,  pointsMax: 10, subject: someSubject)  // 8/10 = 0.8 → 80%
        ]
        
        let result = MarksViewModel.averageMarks(marks: marks)
        // avg = (50 + 100 + 80) / 3 = 230 / 3 ≈ 76.6667
        
        #expect(
            String(format: "%.2f", result) == "76.67",
            "Average should be ~76.67 for values [50, 100, 80]."
        )
    }
}
