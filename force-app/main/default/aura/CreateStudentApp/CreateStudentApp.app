<aura:application controller="CMP_CreateStudentCtrl" access="GLOBAL" extends="force:slds" > 
    <aura:attribute name="student" type="Student__c" default="{ 
        'FirstName__c': '',
        'LastName__c': '',
        'BirthDay__c': '',
        'StudentCode__c':'',
        'Sex__c':'',
        'Class__c': '',
        }"/>
    <aura:attribute name="selectedTab" type="string" />
    <lightning:tabset selectedTabId="{!v.selectedTab}">
        <lightning:tab label="Create" id="one">
            <c:CMP_CreateStudent insertStudent="{!v.student}" selectedTabs="{!v.selectedTab}"/>
        </lightning:tab>
        <lightning:tab label="Update" id="two">
            <c:CMP_UpdateStudent updateStudents="{!v.student}" selectedTabs="{!v.selectedTab}"/>
        </lightning:tab>
        <lightning:tab label="Detail" id="three">
            <c:CMP_DetailStudent detailStudents="{!v.student}" selectedTabs="{!v.selectedTab}"/>
        </lightning:tab>
        </lightning:tabset>
</aura:application>