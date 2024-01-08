
/**
* Class name        : VF_SearchStudentControllerTest
* Class description : 
* @created          : 2023/06/20 Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 
*/
@IsTest
private class VF_SearchStudentControllerTest {

    /**
     * insertStudentSearch
     * Test saveStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void insertStudentSearch()
    {
        Student__c student = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc');
        SearchStudentController ctrl = new SearchStudentController();
    
        Test.startTest();
        ctrl.insertStudent = student;
        ctrl.saveStudent();
        Test.stopTest();

        List<Student__c> afterStudent = [select FirstName__c from Student__c];
        system.assertEquals(afterStudent.size(), 1);
    }
    
    /**
     * updateStudentSearch
     * Test updateStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void updateStudentSearch()
    {
        Student__c student = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc');
        SearchStudentController ctrl = new SearchStudentController();
        insert student;

        Test.startTest();
        ctrl.goToUpdatePage();
        ctrl.updateStudent = new Student__c(id = student.id, FirstName__c = 'Thanh');
        ctrl.updateStudent();
        Test.stopTest();

        List<Student__c> afterStudent = [select FirstName__c from Student__c];
        system.assertEquals(afterStudent[0].FirstName__c, 'Thanh');
    }

    /**
     * deleteStudentSearch
     * Test deleteRow function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void deleteStudentSearch()
    {
        Student__c student = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc');
        SearchStudentController ctrl = new SearchStudentController();
        insert student;

        Test.startTest();
        ctrl.strDeleteId = student.id;
        ctrl.deleteRow();
        Test.stopTest();

        List<Student__c> afterStudent = [select FirstName__c from Student__c];
        system.assertEquals(afterStudent.size(), 0);
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
        Student__c student = new Student__c(FirstName__c = 'Nguyện');
        insert student;
        SearchStudentController ctrl = new SearchStudentController();

        Test.startTest();
        ctrl.getDataById(student.id);
        Test.stopTest();

        List<Student__c> afterStudent = [select FirstName__c from Student__c];
        system.assertEquals(afterStudent[0].FirstName__c, 'Nguyện');
    }

    /**
     * insertClass
     * Test listClass variable
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void insertClass()
    {
        Class__c classNew = new Class__c(ClassName__c = '12A');
        SearchStudentController ctrl = new SearchStudentController();
        insert classNew;

        Test.startTest();
        system.debug(ctrl.listClass);
        system.debug(ctrl.listSex);
        Test.stopTest();

        system.assertEquals(ctrl.listClass.size(), 2);
        system.assertEquals(ctrl.listSex.size(), 3);
    }


    /**
     * detailStudentSearch
     * Test detailStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void detailStudentSearch() 
    {
        Student__c student = new Student__c(FirstName__c = 'Nguyện');
        SearchStudentController ctrl = new SearchStudentController();
        insert student;
        Pagereference pageRef = Page.VF_DetailsStudent;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('detailId',student.Id);

        Test.startTest();
        ctrl.detailStudent();
        Test.stopTest();

        List<Student__c> afterStudent = [select FirstName__c from Student__c];
        system.assertEquals(afterStudent[0].FirstName__c, 'Nguyện');
    }

    /**
     * pagiTable
     * Test pagination function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void pagiTable()
    {
        SearchStudentController ctrl = new SearchStudentController();
        List<Student__c> listStudent = new List<Student__c>();
        for (integer i = 0; i < 10; i++)
        {
            Student__c student = new Student__c(FirstName__c = 'Thanh' + i);
            listStudent.add(student);
        }
        insert listStudent;

        Pagereference pageRef = Page.VF_SearchStudent;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('page', '1');

        ctrl.intPageSize = 2;
        Test.startTest();
        ctrl.getAllStudent();
        ctrl.pagiTable();
        ctrl.changeCurrent();
        ctrl.getListPage();
        Test.stopTest();
        system.assertEquals(ctrl.listPage[0], 1);
        system.assertEquals(ctrl.listPagi.size(), 2);
    }

    /**
     * deleteMultiple
     * Test selectedStudents function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void deleteMultiple()
    {
        SearchStudentController ctrl = new SearchStudentController();
        List<Student__c> listStudent = new List<Student__c>();
        for (integer i = 0; i < 10; i++)
        {
            Student__c student = new Student__c(FirstName__c = 'Thanh' + i);
            listStudent.add(student);
        }
        insert listStudent;

        Test.startTest();
        ctrl.getStudents();
        system.debug(ctrl.listWrapStudents);
        for (integer i = 0; i < 4; i++) 
        {
            ctrl.listWrapStudents[i].selected = true;
        }
        ctrl.selectedStudents();
        Test.stopTest();

        System.assertEquals(ctrl.listSelectedStudents.size(), 4);
    }
}