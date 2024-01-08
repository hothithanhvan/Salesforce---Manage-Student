
/**
* Class name        : CMP_CreateStudentCtrlTest
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/08/22
*/
@IsTest
private class CMP_CreateStudentCtrlTest {
    /**
     * createStudent
     * Save student to database when get data from view
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void createStudent()
    {
        Student__c student = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc');

        Test.startTest();
        CMP_CreateStudentCtrl.createStudent(student);
        Student__c insertStudent = [select id, FirstName__c, LastName__c from Student__c limit 1];
        Test.stopTest();

        System.assertEquals(insertStudent.FirstName__c, 'Nguyện');
    }

    /**
     * updateStudent
     * Test updateStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void updateStudent()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        Student__c updateStudent = new Student__c(FirstName__c = 'Thanh', LastName__c ='Van', Id = insertStudent.Id);

        Test.startTest();
        Student__c student = CMP_CreateStudentCtrl.updateStudent(updateStudent);
        Test.stopTest();

        Student__c afterStudent = [select id, FirstName__c from Student__c limit 1];
        System.assertEquals(afterStudent.FirstName__c, 'Thanh');
    }

    /**
     * getClass
     * Test getClass function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void getClass()
    {
        Class__c newClass = new Class__c(ClassName__c = '12A2');
        insert newClass;

        Test.startTest();
        List<Class__c> listClass = CMP_CreateStudentCtrl.getClass();
        List<Class__c> listClass2 = CMP_SearchStudentCtrl.getClass();
        Test.stopTest();

        System.assertEquals(listClass.size() , 1);
        System.assertEquals(listClass2.size(), 1);
    }
}