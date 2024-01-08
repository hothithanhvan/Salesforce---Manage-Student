/**
 * Class name        : LWC_SearchStudentCtrl
 * Class description :
 * @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
 * @modified         : 2023/07/14
 */

public with sharing class LWC_SearchStudentCtrl 
{

    @TestVisible
    private static Boolean isCatch = false;
    /**
     * createStudent
     * Save student to database when get data from view
     * @param insertStudent
     * @return
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static Student__c createStudent(Student__c insertStudent) 
    {
        try 
        {
            insert insertStudent;
            return insertStudent;
        } 
        catch (Exception e) 
        {
            System.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getClass
     * Get Id and ClassName of Class object
     * @param
     * @return listClass
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled(cacheable=true)
    public static List<Class__c> getClass() 
    {
        List<Class__c> listClass = new List<Class__c>();
        listClass = [SELECT Id, 
                            ClassName__c
                    FROM Class__c
        ];
        return listClass;
    }

    /**
     * searchStudent
     * Search student, include 5 fields
     * @param student, sex
     * @return
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static List<Student__c> searchStudent( Student__c student, String sex, Date birthDayFrom, Date birthDayTo,
                                                String termSearch, String subjectSearch, Decimal scoreFrom, Decimal scoreTo) 
    {
        try 
        {
            string term = termSearch;
            string subject = subjectSearch;
            Decimal scoreF = scoreFrom;
            Decimal scoreT = scoreTo;

            List<Score__c> listScore = new List<Score__c>();
            List<Id> listId = new List<Id>();
            string queryScore = 'select id, Student__c from Score__c ';
            if (termSearch != 'None') 
            {
                queryScore = queryScore + ' where Term__c =: term ';
                if (subjectSearch != 'All') 
                {
                    queryScore = queryScore + ' and Subject__c =: subject ';
                    if (scoreFrom != null && scoreTo != null) 
                    {
                        queryScore = queryScore + ' and avgScore__c >=: scoreF and avgScore__c <=: scoreT';
                    } 
                    else if (scoreFrom != null && scoreTo == null) 
                    {
                        queryScore = queryScore + ' and avgScore__c >=: scoreF';
                    } 
                    else if (scoreFrom == null && scoreTo != null) 
                    {
                        queryScore = queryScore + ' and avgScore__c <=: scoreT';
                    }
                } 
                else if (subjectSearch == 'All') 
                {
                    if (scoreFrom != null && scoreTo != null) 
                    {
                        queryScore = queryScore + ' and avgScore__c >=: scoreF and avgScore__c <=: scoreT';
                    } 
                    else if (scoreFrom != null && scoreTo == null)
                    {
                        queryScore = queryScore + ' and avgScore__c >=: scoreF';
                    } 
                    else if (scoreFrom == null && scoreTo != null) 
                    {
                        queryScore = queryScore + ' and avgScore__c <=: scoreT';
                    }
                }
            } 
            else if (termSearch == 'None') 
            {
                if (subjectSearch != 'All') 
                {
                    queryScore = queryScore + ' where Subject__c =: subject ';
                    if (scoreFrom != null && scoreTo != null) 
                    {
                        queryScore = queryScore + ' and avgScore__c >=: scoreF and avgScore__c <=: scoreT';
                    } 
                    else if (scoreFrom != null && scoreTo == null) 
                    {
                        queryScore = queryScore + ' and avgScore__c >=: scoreF';
                    } 
                    else if (scoreFrom == null && scoreTo != null) 
                    {
                        queryScore = queryScore + ' and avgScore__c <=: scoreT';
                    }
                } 
                else if (subjectSearch == 'All') 
                {
                    if (scoreFrom != null && scoreTo != null) 
                    {
                        queryScore =
                        queryScore +
                        ' where avgScore__c >=: scoreF and avgScore__c <=: scoreT';
                    } 
                    else if (scoreFrom != null && scoreTo == null) 
                    {
                        queryScore = queryScore + ' where avgScore__c >=: scoreF';
                    } 
                    else if (scoreFrom == null && scoreTo != null) 
                    {
                        queryScore = queryScore + ' where avgScore__c <=: scoreT';
                    }
                }
            }
            system.debug(queryScore);
            listScore = Database.query(queryScore);

            for (integer i = 0; i < listScore.size(); i++) 
            {
                listId.add(listScore[i].Student__c);
            }
            system.debug(listId);

            // Fullname
            List<String> listFullName = new List<String>();

            // Set value
            String strSearchFullname = student.FullName__c;

            // Add to list
            listFullName.add('%' + strSearchFullname + '%');

            Date dtSearchDay = student.BirthDay__c;
            String strSearchClass = student.Class__c;
            String strSearchCode = student.StudentCode__c;
            String query =
                'select avgScore__c, Rank__c, TotalCredit__c, FirstName__c, LastName__c, FullName__c, StudentCode__c, Sex__c, Class__c, Class__r.ClassName__c, BirthDay__c from Student__c' +
                ' where FullName__c like: listFullName and id in: listId';

            if (sex == 'male') 
            {
                query += ' and Sex__c = true';
            } 
            else if (sex == 'female') 
            {
                query += ' and Sex__c = false';
            }
            if (strSearchClass != '' && strSearchClass != 'None') 
            {
                query += ' and Class__c =: strSearchClass ';
            }
            if (student.StudentCode__c != '') 
            {
                query += ' and StudentCode__c =: strSearchCode';
            }
            if (birthDayFrom != null && birthDayTo != null) 
            {
                query += ' and BirthDay__c >=: birthDayFrom and BirthDay__c <=: birthDayTo';
            }
            if (birthDayFrom != null && birthDayTo == null) 
            {
                query += ' and BirthDay__c >=: birthDayFrom';
            }
            if (birthDayFrom == null && birthDayTo != null) 
            {
                query += ' and BirthDay__c <=: birthDayTo';
            }
            System.debug(query);
            system.debug(Database.query(query));
            return (Database.query(query));
        } 
        catch (Exception e) 
        {
            system.debug(e);
            return null;
        }
    }

    /**
     * deleteCheck
     * Delete multiple Id
     * @param listId
     * @return
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static void deleteCheck(List<String> listId) 
    {
        try 
        {
            for (Integer i = 0; i < listId.size(); i++) 
            {
                Database.delete(listId[i]);
            }
        } 
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }
    }

    /**
     * deleteOnRow
     * Delete one record
     * @param deleteId
     * @return
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static void deleteOnRow(Id deleteId) 
    {
        try 
        {
            Database.delete(deleteId);
        } 
        catch (Exception e) 
        {
            // throw new AuraHandledException(e.getMessage());
            system.debug(e);
        }
    }

    /**
     * getDetailStudent
     * Get data by Id
     * @param detailId
     * @return
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static Student__c getDetailStudent(Id detailId) 
    {
        try 
        {
            if (isCatch == true) 
            {
                throw new AuraHandledException('no student found');
            }
            return [
                SELECT
                    FirstName__c,
                    LastName__c,
                    FullName__c,
                    StudentCode__c,
                    Class__c,
                    Class__r.ClassName__c,
                    Sex__c,
                    BirthDay__c,
                    avgScore__c,
                    Rank__c,
                    TotalCredit__c
                FROM Student__c
                WHERE Id = :detailId
            ];
        } 
        catch (Exception e) 
        {
            system.debug(e);
            return null;
        }
    }

    /**
     * updateStudent
     * Update student
     * @param updateStudent
     * @return updateStudent
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static Student__c updateStudent(Student__c updateStudent) 
    {
        try 
        {
            update updateStudent;
            return updateStudent;
        } 
        catch (Exception e) 
        {
            System.debug(e.getMessage());
            return null;
        }
    }

    /**
     * getAllStudent
     * Get all student
     * @param
     * @return
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static List<Student__c> getAllStudent() 
    {
        try 
        {
            return [
                SELECT
                    FullName__c,
                    StudentCode__c,
                    Class__c,
                    Class__r.ClassName__c,
                    Sex__c,
                    BirthDay__c,
                    avgScore__c,
                    Rank__c,
                    TotalCredit__c
                FROM Student__c
            ];
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getScore
     * Get score of a student
     * @param termId, studentId
     * @return
     * @created: 2023/07/26 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static List<Score__c> getScore(Id termId, Id studentId) 
    {
        try 
        {
            return [
                SELECT
                    Name,
                    Id,
                    ProcessScore__c,
                    MidtermScore__c,
                    FinaltermScore__c,
                    Subject__r.Name,
                    Subject__r.ProcessPercent__c,
                    Subject__r.MidtermPercent__c,
                    Subject__r.FinaltermPercent__c,
                    Subject__r.Credit__c,
                    Term__r.TermCode__c,
                    avgScore__c
                FROM Score__c
                WHERE Term__c = :termId AND Student__c = :studentId
            ];
        } 
        catch (Exception e) 
        {
            system.debug(e);
            return null;
        }
    }

    /**
     * getTerm
     * Get all term of a student
     * @param studentId
     * @return
     * @created: 2023/07/26 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled(cacheable=true)
    public static List<Term_Student__c> getTerm(Id studentId) 
    {
        try {
            return [
                SELECT 
                    Term__r.Name, 
                    Term__r.Id, 
                    TotalScore__c, 
                    TotalCredit__c
                FROM Term_Student__c
                WHERE Student__r.Id = :studentId
                ORDER BY Term__r.Name ASC
            ];
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getAllScore
     * Get all score of a student
     * @param studentId
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled(cacheable=true)
    public static List<Score__c> getAllScore(Id studentId) 
    {
        try 
        {
            return [
                SELECT
                    Name,
                    Id,
                    ProcessScore__c,
                    MidtermScore__c,
                    FinaltermScore__c,
                    Subject__r.Name,
                    Subject__r.ProcessPercent__c,
                    Subject__r.MidtermPercent__c,
                    Subject__r.FinaltermPercent__c,
                    Subject__r.Credit__c,
                    Term__r.TermCode__c,
                    avgScore__c
                FROM Score__c
                WHERE Student__c = :studentId
            ];
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * getAllTerm
     * Get all term
     * @param studentId
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static List<Term__c> getAllTerm() {
        return [
        SELECT 
            id, 
            Name
        FROM Term__c
        ];
    }

    /** 
     * getAllSubject
     * Get all subject
     * @param studentId
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified
     */
    @AuraEnabled
    public static List<Subject__c> getAllSubject() {
        return [
        SELECT 
            id, 
            Name
        FROM Subject__c
        ];
    }
}
