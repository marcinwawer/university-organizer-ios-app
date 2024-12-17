//
//  MarksView.swift
//  UniversityOrganizer
//
//  Created by Marcin Wawer on 17/12/2024.
//

import SwiftUI
import SwiftData
import Charts

struct MarksView: View {
    @Environment(PlanViewModel.self) private var planVM
    
//    @Query(sort: \Subject.name) private var subjects: [Subject]
    private var subjects = DeveloperPreview.shared.subjects
//    @Query(sort: \Mark.date) private var marks: [Mark]
    private var marks = DeveloperPreview.shared.marks
    
    @State private var isChartVisible: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    title
                    
                    if isChartVisible {
                        chartSection
                            .transition(.move(edge: .top).combined(with: .opacity))
                    } else {
                        chartPlaceholder
                    }
                }
                .padding(.vertical)
                .background(GradientBackground())
                
                subjectsListSection
                
                Spacer()
            }
            .onAppear {
                withAnimation(.bouncy(duration: 0.8)) {
                    isChartVisible = true
                }
            }
            .onDisappear { isChartVisible = false }
        }
    }
}

#Preview {
    MarksView()
        .environment(DeveloperPreview.shared.planVM)
}

extension MarksView {
    private var title: some View {
        HStack {
            Image(systemName: "graduationcap")
                .font(.title)
            
            Text("Marks")
                .font(.largeTitle)
            
            Spacer()
        }
        .fontWeight(.semibold)
        .padding(.leading)
    }
    
    private var chartSection: some View {
        Chart {
            ForEach(marks) { mark in
                LineMark(
                    x: .value("Date", mark.date),
                    y: .value("Percentage", mark.percentage)
                )
                
                PointMark(
                    x: .value("Date", mark.date),
                    y: .value("Percentage", mark.percentage)
                )
                .symbolSize(40)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let percentage = value.as(Double.self) {
                        Text("\(Int(percentage))%")
                            .padding(.trailing)
                    }
                }
            }
        }
        .padding(20)
        .frame(height: 250)
        .background(Color.theme.background.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.bottom, 4)
    }
    
    private var chartPlaceholder: some View {
        RoundedRectangle(cornerRadius: 10)
            .opacity(0)
            .padding(20)
            .frame(height: 250)
            .padding(.horizontal)
            .padding(.bottom, 4)
    }
    
    private var subjectsListSection: some View {
        List(planVM.uniqueSubjects(from: subjects)) { subject in
            ZStack {
                NavigationLink(value: subject) {}.opacity(0)
                
                SubjectListRowView(subject: subject)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationDestination(for: Subject.self) { subject in
            Text(subject.name)
        }
    }
}
