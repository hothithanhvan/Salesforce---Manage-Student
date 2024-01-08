/**
* Class name        : VF_StudentControllerTest
* Class description : 
* @created          : 2023/06/20 Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 
*/
@IsTest
private class VF_StudentControllerTest {

    /**
     * insertStudent
     * Test insertStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void insertStudent()
    {
        Student__c student = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc');
        StudentController ctrl = new StudentController();
    
        Test.startTest();
        ctrl.insertStudent = student;
        ctrl.saveStudent();
        ctrl.strId = ctrl.insertStudent.id;
        ctrl.goToUpdatePage();
        ctrl.updateStudent = new Student__c(id = ctrl.insertStudent.id, FirstName__c = 'Thanh');
        ctrl.updateStudent();
        Test.stopTest();

        Student__c afterStudent = [select FirstName__c from Student__c where FirstName__c = 'Thanh' limit 1];
        System.assertEquals(afterStudent.FirstName__c, 'Thanh');
    }

    /**
     * deleteStudent
     * Test deleteStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void deleteStudent()
    {
        Student__c student = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc');
        insert student;
        StudentController ctrl = new StudentController();

        Test.startTest();
        ctrl.strId = student.id;
        ctrl.deleteStudent();
        Test.stopTest();

        List<Student__c> afterStudent = [select FirstName__c from Student__c];
        System.assertEquals(afterStudent.size(), 0);
    }

    /**
     * detailStudent
     * test detailStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void detailStudent()
    {
        Student__c student = new Student__c(FirstName__c = 'Nguyện');
        Class__c classNew = new Class__c(ClassName__c = '12A1');
        insert classNew;
        insert student;
        StudentController ctrl = new StudentController();
        Pagereference pageRef = Page.VF_DetailsStudent;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',student.Id);

        Test.startTest();
        ctrl.detailStudent();
        system.debug(ctrl.listClass);
        Test.stopTest();

        system.assertEquals(ctrl.detailStudent.FirstName__c, 'Nguyện');

    }
}