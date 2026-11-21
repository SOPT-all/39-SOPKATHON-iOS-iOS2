//
//  ChildFormView.swift
//  sopkathon-ios2
//
//  Created by bomin on 11/22/26.
//

import SwiftUI

struct ChildFormView: View {
    @Binding private var childName: String
    @Binding private var birthDate: Date?
    @Binding private var gender: ChildGenderModel?
    @Binding private var parentName: String
    @Binding private var parentPhoneNumber: String
    @Binding private var relationship: ChildRelationshipModel?
    @Binding private var notes: String

    @FocusState private var focusedField: Field?
    @State private var isBirthDatePickerPresented = false
    @State private var selectedBirthDate = Date()

    private let isValidParentPhoneNumber: Bool

    init(
        childName: Binding<String>,
        birthDate: Binding<Date?>,
        gender: Binding<ChildGenderModel?>,
        parentName: Binding<String>,
        parentPhoneNumber: Binding<String>,
        relationship: Binding<ChildRelationshipModel?>,
        notes: Binding<String>,
        isValidParentPhoneNumber: Bool
    ) {
        _childName = childName
        _birthDate = birthDate
        _gender = gender
        _parentName = parentName
        _parentPhoneNumber = parentPhoneNumber
        _relationship = relationship
        _notes = notes
        self.isValidParentPhoneNumber = isValidParentPhoneNumber
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            childSectionView
                .padding(.top, Metric.topPadding)
                .padding(.bottom, Metric.sectionBottomPadding)

            Color.gray50
                .frame(height: Metric.sectionDividerHeight)

            parentSectionView
                .padding(.top, Metric.sectionTitleTopPadding)
                .padding(.bottom, Metric.bottomPadding)
        }
        .onChange(of: parentPhoneNumber) { _, newValue in
            let formattedValue = newValue.formattedPhoneNumber
            guard formattedValue != newValue else { return }
            parentPhoneNumber = formattedValue
        }
    }

    private var childSectionView: some View {
        VStack(alignment: .leading, spacing: Metric.fieldSpacing) {
            textFieldView(title: Title.childName, text: $childName, field: .childName)

            birthDateFieldView

            dropdownFieldView(
                title: Title.gender,
                selection: $gender,
                options: ChildGenderModel.allCases,
                optionTitle: \.title
            )
        }
        .padding(.horizontal, Metric.horizontalPadding)
    }

    private var parentSectionView: some View {
        VStack(alignment: .leading, spacing: Metric.fieldSpacing) {
            Text(Title.parentSection)
                .typography(.body2)
                .foregroundStyle(Color.textBlack)
                .padding(.bottom, Metric.sectionTitleBottomPadding - Metric.fieldSpacing)

            textFieldView(title: Title.parentName, text: $parentName, field: .parentName)

            phoneNumberFieldView

            dropdownFieldView(
                title: Title.relationship,
                selection: $relationship,
                options: ChildRelationshipModel.allCases,
                optionTitle: \.title
            )
            .padding(.bottom, Metric.notesTopPadding - Metric.fieldSpacing)

            notesFieldView
        }
        .padding(.horizontal, Metric.horizontalPadding)
    }

    private var birthDateFieldView: some View {
        labeledView(title: Title.birthDate) {
            Button {
                focusedField = nil
                selectedBirthDate = birthDate ?? Date()
                isBirthDatePickerPresented = true
            } label: {
                HStack {
                    birthDateTextView

                    Spacer()

                    chevronView
                }
                .padding(.horizontal, Metric.fieldHorizontalPadding)
                .frame(height: Metric.fieldHeight)
                .background(Color.gray50, in: fieldShape)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .bottomSheet(isPresented: $isBirthDatePickerPresented, title: Title.birthDate) {
            birthDatePickerView
        }
    }

    @ViewBuilder
    private var birthDateTextView: some View {
        if let birthDate {
            Text(birthDate.formatted(Format.birthDate))
                .typography(.body5)
                .foregroundStyle(Color.textBlack)
        } else {
            Text(Title.placeholder)
                .typography(.body5)
                .foregroundStyle(Color.disabled200)
        }
    }

    private var birthDatePickerView: some View {
        VStack(spacing: Metric.pickerSpacing) {
            DatePicker(
                "",
                selection: $selectedBirthDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .environment(\.locale, Format.locale)

            FullWidthButton(title: Title.confirm) {
                birthDate = selectedBirthDate
                isBirthDatePickerPresented = false
            }
        }
    }

    private var phoneNumberFieldView: some View {
        let hasError = focusedField != .parentPhoneNumber
            && !parentPhoneNumber.isEmpty
            && !isValidParentPhoneNumber

        return labeledView(title: Title.parentPhoneNumber) {
            VStack(alignment: .leading, spacing: Metric.labelSpacing) {
                TextField(Title.phoneNumberPlaceholder, text: $parentPhoneNumber)
                    .keyboardType(.numberPad)
                    .modifier(
                        ChildFormFieldStyle(
                            isFocused: focusedField == .parentPhoneNumber,
                            hasError: hasError
                        )
                    )
                    .focused($focusedField, equals: .parentPhoneNumber)

                if hasError {
                    Text(Title.phoneNumberError)
                        .typography(.caption3)
                        .foregroundStyle(Color(.systemRed))
                }
            }
        }
    }

    private var notesFieldView: some View {
        labeledView(title: Title.notes) {
            TextEditor(text: $notes)
                .typography(.body5)
                .foregroundStyle(Color.textBlack)
                .scrollContentBackground(.hidden)
                .focused($focusedField, equals: .notes)
                .padding(.horizontal, Metric.notesInnerPadding)
                .padding(.vertical, Metric.notesInnerPadding)
                .frame(height: Metric.notesHeight)
                .background(Color.gray50, in: notesShape)
                .overlay {
                    notesShape.strokeBorder(
                        focusedField == .notes ? Color.gray200 : .clear,
                        lineWidth: Metric.borderWidth
                    )
                }
        }
    }

    private var chevronView: some View {
        Image(.iconChevronDown)
    }

    private var fieldShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: Metric.fieldCornerRadius)
    }

    private var notesShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: Metric.notesCornerRadius)
    }

    private func labeledView(
        title: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: Metric.labelSpacing) {
            Text(title)
                .typography(.body2)
                .foregroundStyle(Color.textBlack)

            content()
        }
    }

    private func textFieldView(
        title: String,
        text: Binding<String>,
        field: Field
    ) -> some View {
        labeledView(title: title) {
            TextField("", text: text)
                .modifier(ChildFormFieldStyle(isFocused: focusedField == field, hasError: false))
                .focused($focusedField, equals: field)
        }
    }

    private func dropdownFieldView<Option: Hashable>(
        title: String,
        selection: Binding<Option?>,
        options: [Option],
        optionTitle: @escaping (Option) -> String
    ) -> some View {
        labeledView(title: title) {
            HStack {
                Text(selection.wrappedValue.map(optionTitle) ?? Title.placeholder)
                    .typography(.body5)
                    .foregroundStyle(
                        selection.wrappedValue == nil ? Color.disabled200 : Color.textBlack
                    )

                Spacer()

                chevronView
            }
            .padding(.horizontal, Metric.fieldHorizontalPadding)
            .frame(height: Metric.fieldHeight)
            .background(Color.gray50, in: fieldShape)
            .overlay {
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(optionTitle(option)) {
                            selection.wrappedValue = option
                        }
                    }
                } label: {
                    Color.clear
                        .contentShape(Rectangle())
                }
                .simultaneousGesture(TapGesture().onEnded { focusedField = nil })
            }
        }
    }
}

private struct ChildFormFieldStyle: ViewModifier {
    let isFocused: Bool
    let hasError: Bool

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: ChildFormView.Metric.fieldCornerRadius)

        content
            .typography(.body5)
            .foregroundStyle(Color.textBlack)
            .padding(.horizontal, ChildFormView.Metric.fieldHorizontalPadding)
            .frame(height: ChildFormView.Metric.fieldHeight)
            .background(Color.gray50, in: shape)
            .overlay {
                shape.strokeBorder(borderColor, lineWidth: ChildFormView.Metric.borderWidth)
            }
    }

    private var borderColor: Color {
        if hasError {
            return Color(.systemRed)
        }
        return isFocused ? Color.gray200 : .clear
    }
}

private extension ChildFormView {
    enum Field {
        case childName
        case parentName
        case parentPhoneNumber
        case notes
    }

    enum Metric {
        static let horizontalPadding: CGFloat = 24
        static let topPadding: CGFloat = 18
        static let bottomPadding: CGFloat = 12
        static let sectionBottomPadding: CGFloat = 15
        static let sectionDividerHeight: CGFloat = 9
        static let sectionTitleTopPadding: CGFloat = 19
        static let sectionTitleBottomPadding: CGFloat = 43
        static let fieldSpacing: CGFloat = 9
        static let notesTopPadding: CGFloat = 22
        static let labelSpacing: CGFloat = 6
        static let fieldHeight: CGFloat = 43
        static let fieldHorizontalPadding: CGFloat = 12
        static let fieldCornerRadius: CGFloat = 10
        static let notesHeight: CGFloat = 80
        static let notesCornerRadius: CGFloat = 4
        static let notesInnerPadding: CGFloat = 8
        static let borderWidth: CGFloat = 1
        static let pickerSpacing: CGFloat = 16
    }

    enum Title {
        static let childName = "아이 이름"
        static let birthDate = "생년월일"
        static let gender = "성별"
        static let parentSection = "학부모 연락처"
        static let parentName = "학부모 이름"
        static let parentPhoneNumber = "휴대폰 번호"
        static let relationship = "관계"
        static let notes = "특이사항 및 알레르기"
        static let placeholder = "Select…"
        static let phoneNumberPlaceholder = "010-0000-0000"
        static let phoneNumberError = "휴대폰 번호 형식을 확인해 주세요"
        static let confirm = "선택 완료"
    }

    enum Format {
        static let locale = Locale(identifier: "ko_KR")
        static let birthDate = Date.FormatStyle(date: .long, time: .omitted, locale: locale)
    }
}
