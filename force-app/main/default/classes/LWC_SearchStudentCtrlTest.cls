/**
 * Class name        : LWC_SearchStudentCtrlTest
 * Class description :
 * @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
 * @modified         : 2023/07/14
 */
@IsTest
private class LWC_SearchStudentCtrlTest 
{
    
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
        List<Class__c> listClass = LWC_SearchStudentCtrl.getClass();
        Test.stopTest();
        System.assertEquals(listClass.size(), 1);
    }

    /**
     * insertStudent
     * Test createStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void insertStudent() 
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);

        Test.startTest();
        LWC_SearchStudentCtrl.createStudent(insertStudent);
        Test.stopTest();

        List<Student__c> listStudent = [SELECT id FROM Student__c];
        System.assertEquals(listStudent.size(), 1);
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
        Class__c newClass = new Class__c(ClassName__c = '12A');
        insert newClass;
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', 
                                                  Class__c = newClass.Id, Sex__c = true);
        insert insertStudent;
        Student__c searchStudent = [
                                    SELECT
                                        FirstName__c,
                                        LastName__c,
                                        FullName__c,
                                        StudentCode__c,
                                        Birthday__c,
                                        Class__c
                                    FROM Student__c
                                    LIMIT 1
                                    ];
        String sex = 'male';
        Term__c term = new Term__c(Name = 'Học kỳ 1');
        Subject__c subject = new Subject__c(Name = 'Toán', ProcessPercent__c = 10, MidtermPercent__c = 30,
                                            FinaltermPercent__c = 60, Credit__c = 5);
        insert term;
        insert subject;
        Score__c score = new Score__c(ProcessScore__c = 9, MidtermScore__c = 10, FinaltermScore__c = 10,
                                     Term__c = term.Id, Student__c = insertStudent.Id, Subject__c = subject.Id);
        insert score;

        Test.startTest();
        List<Student__c> listStudent = LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null,
                                                                        null, term.Id, subject.Id, 0, 10);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            term.Id, subject.Id, 0, null);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            term.Id, subject.Id, null, 9);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            term.Id, subject.Id, null, null);

        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            'None', subject.Id, 0, 10);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            'None', subject.Id, null, 10);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            'None', subject.Id, 0, null);

        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            term.Id, 'All', 0, 10);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            term.Id, 'All', null, 10);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            term.Id, 'All', 0, null);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            term.Id, 'All', null, null);

        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            'None', 'All', null, null);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            'None', 'All', null, 9);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            'None', 'All', 9, null);
        LWC_SearchStudentCtrl.searchStudent(searchStudent, sex, null, null, 
                                            'None', 'All', 9, 9);
        Test.stopTest();
        System.assertNotEquals(listStudent.size(), 0);
    }

    /**
     * deleteCheck
     * Test deleteCheck function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void deleteCheck() 
    {
        List<Student__c> listStudent = new List<Student__c>();
        for (Integer i = 0; i < 5; i++) 
        {
            Student__c insertStudent = new Student__c(FirstName__c = 'Thanh' + i, LastName__c = 'Van');
            listStudent.add(insertStudent);
        }
        insert listStudent;
        List<Id> listId = new List<Id>();
        for (integer i = 0; i < listStudent.size(); i++) 
        {
            listId.add(listStudent[i].Id);
        }

        Test.startTest();
        LWC_SearchStudentCtrl.deleteCheck(listId);
        Test.stopTest();

        List<Student__c> afterDelete = [SELECT id FROM Student__c];
        System.assertEquals(afterDelete.size(), 0);
    }

    /**
     * deleteOnRow
     * Test deleteOnRow function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void deleteOnRow() 
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;

        Test.startTest();
        LWC_SearchStudentCtrl.deleteOnRow(insertStudent.Id);
        Test.stopTest();

        List<Student__c> afterDelete = [SELECT id FROM Student__c];
        System.assertEquals(afterDelete.size(), 0);
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
        Student__c student = LWC_SearchStudentCtrl.getDetailStudent(insertStudent.Id);
        Test.stopTest();

        Student__c afterStudent = [SELECT id, FirstName__c FROM Student__c LIMIT 1];
        System.assertEquals(afterStudent.FirstName__c, 'Nguyện');
    }

    /**
     * getClass
     * Test getClass function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void getDetailStudentFail() 
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;

        Test.startTest();
        LWC_SearchStudentCtrl.isCatch = true;
        LWC_SearchStudentCtrl.getDetailStudent(insertStudent.Id);
        Test.stopTest();

    }

    /**
     * deleteStudentFail
     * Test deleteOnRow function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void deleteStudentFail() 
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        string id = insertStudent.id;
        delete insertStudent;

        Test.startTest();
        LWC_SearchStudentCtrl.deleteOnRow(id);
        Test.stopTest();

        List<Student__c> afterStudent = [SELECT id, FirstName__c FROM Student__c];
        System.assertEquals(afterStudent.size(), 0);
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
        Student__c updateStudent = new Student__c(FirstName__c = 'Thanh', LastName__c = 'Van', Id = insertStudent.Id);

        Test.startTest();
        Student__c student = LWC_SearchStudentCtrl.updateStudent(updateStudent);
        Test.stopTest();

        Student__c afterStudent = [SELECT id, FirstName__c FROM Student__c LIMIT 1];
        System.assertEquals(afterStudent.FirstName__c, 'Thanh');
    }

    /**
     * getAllStudent
     * Test getAllStudent function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void getAllStudent() 
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;

        Test.startTest();
        List<Student__c> listStudent = LWC_SearchStudentCtrl.getAllStudent();
        Test.stopTest();

        List<Student__c> afterStudent = [SELECT id, FirstName__c FROM Student__c];
        System.assertEquals(afterStudent.size(), 1);
    }

    /**
     * getScore
     * Test getScore function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    @IsTest
    static void getScore() 
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        Term__c term = new Term__c(Name = 'Học kỳ 1');
        Subject__c subject = new Subject__c(Name = 'Toán', ProcessPercent__c = 10, MidtermPercent__c = 30, 
                                            FinaltermPercent__c = 60, Credit__c = 5);

        insert term;
        insert subject;
        Score__c score = new Score__c(ProcessScore__c = 9, MidtermScore__c = 10, FinaltermScore__c = 10,
                                      Term__c = term.Id, Student__c = insertStudent.Id, Subject__c = subject.Id);

        insert score;

        Test.startTest();
        List<Score__c> listScore = LWC_SearchStudentCtrl.getScore(term.Id, insertStudent.Id);
        List<Score__c> listScore2 = LWC_SearchStudentCtrl.getAllScore(insertStudent.Id);
        List<Term_Student__c> listTerm = LWC_SearchStudentCtrl.getTerm(insertStudent.Id);
        Test.stopTest();

        System.assertEquals(listScore.size(), 1);
        System.assertEquals(listScore2.size(), 1);
        System.assertEquals(listTerm.size(), 1);
    }

    /**
     * getAllTerm
     * Test getAllTerm function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void getAllTerm() 
    {
        Term__c term = new Term__c(Name = 'Học kỳ 1');
        insert term;
        Test.startTest();
        List<Term__c> listTerm = LWC_SearchStudentCtrl.getAllTerm();
        Test.stopTest();
        System.assertEquals(listTerm.size(), 1);
    }

    /**
     * getAllSubject
     * Test getAllSubject function
     * @param
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void getAllSubject() 
    {
        Subject__c subject = new Subject__c(Name = 'Toán');
        insert subject;
        Test.startTest();
        List<Subject__c> listSubject = LWC_SearchStudentCtrl.getAllSubject();
        Test.stopTest();
        System.assertEquals(listSubject.size(), 1);
    }
}
