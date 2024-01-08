/**
* Class name        : CMP_CreateStudentCtrl
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/07/04
*/

public with sharing class CMP_CreateStudentCtrl 
{

    /**
     * createStudent
     * Save student to database when get data from view
     * @param student
     * @return
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static Student__c createStudent(Student__c student)
    { 
        insert student;
        Id Id = student.Id;
        return [
            SELECT 
                FirstName__c, 
                LastName__c, 
                StudentCode__c, 
                Class__c, 
                Class__r.ClassName__c,
                Sex__c, 
                BirthDay__c 
            FROM Student__c 
            where Id=: Id];
    }

    /**
     * deleteStudent
     * Delete student
     * @param student
     * @return
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static void deleteStudent(Student__c student)
    {
        try 
        {
            database.delete(student);
        } 
        catch (Exception e) 
        {
            system.debug(e);
        }
    }

    /** 
     * getClass
     * Get class id and classname of Class object
     * @param
     * @return listClass
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static List<Class__c> getClass()
    {
        
        List <Class__c> listClass = new List<Class__c>();
        listClass = [
            Select
                Id,
                ClassName__c 
            From Class__c
            ];
           
        return listClass;
    }

    /** 
     * getDetailStudent
     * Get detail of student 
     * @param Id
     * @return detailStudent
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static Student__c getDetailStudent(Id Id)
    {
        Student__c detailStudent = 
        [
            SELECT 
                FirstName__c, 
                LastName__c, 
                StudentCode__c, 
                Class__c, 
                Class__r.ClassName__c,
                Sex__c, 
                BirthDay__c 
            FROM Student__c 
            where Id=: Id];
        return detailStudent;
    }

    /** 
     * updateStudent
     * Update student
     * @param student
     * @return student
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static Student__c updateStudent(Student__c student)
    {
        update student;
        Id Id = student.Id;
        return [
            SELECT 
                FirstName__c, 
                LastName__c, 
                StudentCode__c, 
                Class__c, 
                Class__r.ClassName__c,
                Sex__c, 
                BirthDay__c 
            FROM Student__c 
            where Id=: Id];
    }
}