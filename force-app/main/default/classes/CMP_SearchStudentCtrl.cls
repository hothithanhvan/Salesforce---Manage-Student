/**
* Class name        : CMP_SearchStudentCtrl
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/07/04
*/

public with sharing class CMP_SearchStudentCtrl 
{
    /**
     * getClass
     * Get Id and ClassName of Class object
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
                Id, ClassName__c 
            From Class__c
            ];
           
        return listClass;
    }

    /**
     * searchStudent
     * Search student
     * @param searchStudent, Sex
     * @return 
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static List<Student__c> searchStudent(Student__c searchStudent, string Sex)
    {
        // Fullname
         List<String> listFullName = new List<String>();
         // Set value
         String strSearchFullname = searchStudent.FullName__c;
         // Add to list
         listFullName.add('%'+strSearchFullname+'%');

         Date dtSearchDay = searchStudent.BirthDay__c;
         String strSearchClass = searchStudent.Class__c;
         String strSearchCode = searchStudent.StudentCode__c;
         String query = 'select FirstName__c, LastName__c, FullName__c, StudentCode__c, Sex__c, Class__c, Class__r.ClassName__c, BirthDay__c from Student__c' +
         ' where FullName__c like: listFullName ';
        
        if (Sex == 'male')
        {   
            query += ' and Sex__c = true'; 
        }
        else if (Sex == 'female')
        {
            query += ' and Sex__c = false';
        }
        if (strSearchClass != '' && strSearchClass != 'None' )
        { 
            query+= ' and Class__c =: strSearchClass ';
        }
         if (searchStudent.StudentCode__c != '')
         {
             query += ' and StudentCode__c =: strSearchCode';
         }
         if (searchStudent.BirthDay__c != null)
         {
             query += ' and BirthDay__c =: dtSearchDay';
         }
         
         system.debug(Database.query(query));
        return (Database.query(query));
    }


    /**
     * delStudentById
     * Delete single record
     * @param Id
     * @return 
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static void delStudentById(string Id) 
    {
        try 
        {
            database.delete(Id);

        } 
        catch (Exception e) 
        {
            system.debug(e);
        }
    }

    /**
     * getDataById
     * Get data by Id
     * @param Id
     * @return 
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static Student__c getDataById(String Id)
    {
        return
        [
            select 
                StudentCode__c, 
                FirstName__c, 
                LastName__c, 
                BirthDay__c, 
                Sex__c,
                Class__r.ClassName__c,
                Class__c
            from Student__c 
            where id=: Id 
            limit 1
        ];
    }

    /**
     * deleteMultiple
     * Delete multiple Id
     * @param listDelete
     * @return 
     * @created: 2023/07/04 Ho Thi Thanh Van
     * @modified 
     */
    @AuraEnabled
    public static void deleteMultiple(List<String> listDelete)
    {
        try 
        {
            for (Integer i = 0; i < listDelete.size(); i++)
            {
                Database.delete(listDelete[i]);
            }
            } 
        catch (Exception e) 
        {
            system.debug(e);
        }
        
    }
}