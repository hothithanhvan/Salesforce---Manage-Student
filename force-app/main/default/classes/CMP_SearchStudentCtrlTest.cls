/**
* Class name        : CMP_SearchStudentCtrlTest
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/08/22
*/
@IsTest
private class CMP_SearchStudentCtrlTest {

    /**
     * delStudentById
     * Test delStudentById function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void delStudentById()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        Test.startTest();
        CMP_SearchStudentCtrl.delStudentById(insertStudent.Id);
        Test.stopTest();
        List<Student__c> afterDelete = [select id from Student__c];
        System.assertEquals(afterDelete.size(), 0);
    }

    /**
     * getDataById
     * Test getDataById function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void getDataById()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        string Id = insertStudent.Id;
        Test.startTest();
        Student__c student = CMP_SearchStudentCtrl.getDataById(Id);
        Test.stopTest();
        Student__c afterStudent = [select id, FirstName__c from Student__c limit 1];
        System.assertEquals(afterStudent.FirstName__c, 'Nguyện');
    }

    /**
     * getDetailStudent
     * Test getDetailStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    
    static testMethod void getDetailStudent()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        Test.startTest();
        Student__c student = CMP_CreateStudentCtrl.getDetailStudent(insertStudent.Id);
        Test.stopTest();
        Student__c afterStudent = [select id, FirstName__c from Student__c limit 1];
        System.assertEquals(afterStudent.FirstName__c, 'Nguyện');
    }

    /**
     * searchStudent
     * Test searchStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void searchStudent()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        Student__c searchStudent = [select FirstName__c, LastName__c, FullName__c, StudentCode__c, Birthday__c, Class__c from Student__c limit 1];
        String sex = 'male';

        Test.startTest();
        List<Student__c> listStudent = CMP_SearchStudentCtrl.searchStudent(searchStudent, sex);
        Test.stopTest();

        System.assertNotEquals(listStudent.size(), 0);
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
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;

        Test.startTest();
        CMP_CreateStudentCtrl.deleteStudent(insertStudent);
        Test.stopTest();

        List<Student__c> afterDelete = [select id from Student__c];
        System.assertEquals(afterDelete.size(), 0);
    }

    /**
     * deleteMultiple
     * Test deleteMultiple function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void deleteMultiple()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc');
        Student__c insertStudent1 = new Student__c(FirstName__c = 'Thanh', LastName__c = 'Vân');
        insert insertStudent;
        insert insertStudent1;
        List<Id> listId = new List<Id>();
        listId.add(insertStudent.Id);
        listId.add(insertStudent1.Id);

        Test.startTest();
        CMP_SearchStudentCtrl.deleteMultiple(listId);
        Test.stopTest();

        List<Student__c> listStudent = [select id from Student__c];
        System.assertEquals(listStudent.size(), 0);
    }
}