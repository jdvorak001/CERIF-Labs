# Adaptation of the CERIF Template XML Schema for the NL P-O-P Profile

## 1. Namespace

Use `urn:xmlns:nl:pop-project:cerif-profile-1.0-EXPERIMENTAL` as the namespace (i.e., as `targetNamespace` of the schema as well as the default namespace).

## 2. Add the `FundingAwardNotice` element

	<xs:element name="FundingAwardNotice">
		<xs:complexType>
			<xs:sequence>
				<xs:element ref="Project"/>
			</xs:sequence>
		</xs:complexType>
	</xs:element>

## 3. Remove all CERIF elements except for `Person`, `PersonName`, `OrgUnit`, `Project`, and `Funding`

Leave the substition group heads though.

## 4. Add project roles

### Add `Secretariat` and `Collaboration` to the admissible roles in the project consortium

Make `Secretariat` and `Collaboration` go before `Member` i.e., use the `AdditionalProjectConsortiumRoles` extension point.

### Add `Supervisor`, `CoSupervisor` and `DoctoralStudent` to the admissible roles in the project team

Add these roles to the `AdditionalProjectTeamRoles` extension point.

## 5. Add the Narcis subject classification to projects

At the `ProjectSubjectClassifications` extension point the reference to the XML Schema containing the specific `Subject` element in the `urn:xmlns:nl:pop-project:vocab:Subjects#` namespace shall be made, thus:

	<xs:element ref="Subject" xmlns="urn:xmlns:nl:pop-project:vocab:Subjects#" minOccurs="0" maxOccurs="unbounded">
		<xs:annotation>
			<xs:documentation>The subject classification(s) of the project</xs:documentation>
		</xs:annotation>
	</xs:element>

In the beginning of the schema, the following import shall be added:

	<xs:import namespace="urn:xmlns:nl:pop-project:vocab:Subjects#" schemaLocation="./subjects.xsd">
		<xs:annotation>
	         <xs:documentation xml:lang="en">The discipline classification used in NARCIS</xs:documentation>
		</xs:annotation>
	</xs:import>

## 6. Add the `Costs` section to projects

## 7. Add the `CoveredBy` and `ApplicationWithin` sections to funding

