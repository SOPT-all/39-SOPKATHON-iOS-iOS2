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
    @State private var presentedPicker: PickerType?
    @State private var selectedBirthDate = Date()
    @State private var selectedGender = ChildGenderModel.male
    @State private var selectedRelationship = ChildRelationshipModel.mother

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
    }

    private var childSectionView: some View {
        VStack(alignment: .leading, spacing: Metric.fieldSpacing) {
            textFieldView(title: Title.childName, text: $childName, field: .childName)

            birthDateFieldView

            genderFieldView
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

            relationshipFieldView
                .padding(.bottom, Metric.notesTopPadding - Metric.fieldSpacing)

            notesFieldView
        }
        .padding(.horizontal, Metric.horizontalPadding)
    }

    private var birthDateFieldView: some View {
        selectFieldView(title: Title.birthDate, value: birthDate?.formatted(Format.birthDate)) {
            selectedBirthDate = birthDate ?? Date()
            presentedPicker = .birthDate
        }
        .bottomSheet(isPresented: isPresented(.birthDate), title: Title.birthDate) {
            pickerSheetView {
                DatePicker(
                    "",
                    selection: $selectedBirthDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Format.locale)
            } onConfirm: {
                birthDate = selectedBirthDate
            }
        }
    }

    private var genderFieldView: some View {
        selectFieldView(title: Title.gender, value: gender?.title) {
            selectedGender = gender ?? .male
            presentedPicker = .gender
        }
        .bottomSheet(isPresented: isPresented(.gender), title: Title.gender) {
            pickerSheetView {
                Picker("", selection: $selectedGender) {
                    ForEach(ChildGenderModel.allCases, id: \.self) { gender in
                        Text(gender.title)
                            .tag(gender)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
            } onConfirm: {
                gender = selectedGender
            }
        }
    }

    private var relationshipFieldView: some View {
        selectFieldView(title: Title.relationship, value: relationship?.title) {
            selectedRelationship = relationship ?? .mother
            presentedPicker = .relationship
        }
        .bottomSheet(isPresented: isPresented(.relationship), title: Title.relationship) {
            pickerSheetView {
                Picker("", selection: $selectedRelationship) {
                    ForEach(ChildRelationshipModel.allCases, id: \.self) { relationship in
                        Text(relationship.title)
                            .tag(relationship)
                    }
                }
                .pickerStyle(.wheel)
                .labelsHidden()
            } onConfirm: {
                relationship = selectedRelationship
            }
        }
    }

    private var phoneNumberFieldView: some View {
        let hasError = !parentPhoneNumber.isEmpty && !isValidParentPhoneNumber

        return labeledView(title: Title.parentPhoneNumber) {
            SingleLineTextField(
                text: $parentPhoneNumber,
                placeholder: Title.phoneNumberPlaceholder,
                inputType: .phoneNumber,
                errorMessage: hasError ? Title.phoneNumberError : nil
            )
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
                .modifier(ChildFormFieldStyle(isFocused: focusedField == field))
                .focused($focusedField, equals: field)
        }
    }

    private func selectFieldView(
        title: String,
        value: String?,
        action: @escaping () -> Void
    ) -> some View {
        labeledView(title: title) {
            Button {
                hideKeyboard()
                action()
            } label: {
                HStack {
                    Text(value ?? Title.placeholder)
                        .typography(.body5)
                        .foregroundStyle(value == nil ? Color.disabled200 : Color.textBlack)

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
    }

    private func pickerSheetView(
        @ViewBuilder picker: () -> some View,
        onConfirm: @escaping () -> Void
    ) -> some View {
        VStack(spacing: Metric.pickerSpacing) {
            picker()

            FullWidthButton(title: Title.confirm) {
                onConfirm()
                presentedPicker = nil
            }
        }
    }

    private func isPresented(_ picker: PickerType) -> Binding<Bool> {
        Binding(
            get: { presentedPicker == picker },
            set: { isPresented in
                guard !isPresented else { return }
                presentedPicker = nil
            }
        )
    }
}

private struct ChildFormFieldStyle: ViewModifier {
    let isFocused: Bool

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: ChildFormView.Metric.fieldCornerRadius)

        content
            .typography(.body5)
            .foregroundStyle(Color.textBlack)
            .padding(.horizontal, ChildFormView.Metric.fieldHorizontalPadding)
            .frame(height: ChildFormView.Metric.fieldHeight)
            .background(Color.gray50, in: shape)
            .overlay {
                shape.strokeBorder(
                    isFocused ? Color.gray200 : .clear,
                    lineWidth: ChildFormView.Metric.borderWidth
                )
            }
    }
}

private extension ChildFormView {
    enum Field {
        case childName
        case parentName
        case notes
    }

    enum PickerType {
        case birthDate
        case gender
        case relationship
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
