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
    
    @Query(sort: \Subject.name) private var subjects: [Subject]
    @Query(sort: \Mark.date) private var marks: [Mark]
    
    @State private var vm: MarksViewModel
    @State private var isChartVisible: Bool = false
    
    init() {
        _vm = State(wrappedValue: MarksViewModel(marks: []))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    title
                    
                    if !vm.marks.isEmpty {
                        if isChartVisible {
                            chartSection
                                .transition(.move(edge: .top).combined(with: .opacity))
                        } else {
                            chartPlaceholder
                        }
                    } else {
                        EmptyMarksView()
                    }
                }
                .padding(.vertical)
                .background(GradientBackground())
                
                if !subjects.isEmpty {
                    subjectsListSection
                        .navigationDestination(for: Subject.self) { subject in
                            MarksDetailView(vm: vm, subject: subject)
                        }
                } else {
                    NoClassesView()
                }
                
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                vm.marks = marks
                
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
            ForEach(vm.marks) { mark in
                LineMark(
                    x: .value("Date", mark.date.strippedTime()),
                    y: .value("Percentage", mark.percentage)
                )
                
                PointMark(
                    x: .value("Date", mark.date.strippedTime()),
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
        List {
            ForEach(planVM.uniqueSubjects(from: subjects)) { subject in
                ZStack {
                    NavigationLink(value: subject) {}.opacity(0)
                    
                    SubjectListRowView(subject: subject)
                }
                .listRowSeparator(.hidden)
            }
            
            Spacer()
                .frame(height: 65)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
