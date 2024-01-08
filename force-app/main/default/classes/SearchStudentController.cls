/**
* Class name        : SearchStudent
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/06/20
*/

public with sharing class SearchStudentController 
{
    // Get information to search for students
    public Student__c searchStudent{get; set;}

    // Get class to display in dropdown
    public List<Class__c> listClassTemp = new List<Class__c>();

    // Get list of student
    private List<Student__c> listStudent{get; set;}

    // Store value of Sex in dropdown
    public string strSexTemp{get; set;}

    // Get Id to delete, show detail, update
    public string strId{get; set;}

    // Get Id to delete
    public string strDeleteId{get; set;}

    // Get information to insert student
    public Student__c insertStudent {get; set;}

     // Get information to show detail
     public Student__c detailStudent{get; set;}

     // Get information of update student
     public Student__c updateStudent{get; set;}
     
     // Get list of id checked by string
     public String strListId{get; set;}
    
    /**
     * SearchStudent
     * Constructor
     * @param 
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    public SearchStudentController() 
    {

        this.intPageCount = 0;
        this.intPageSize = 3;
        this.listPage = new List<Integer>();
        this.searchStudent = new Student__c();
        this.insertStudent = new Student__c();
        this.detailStudent = new Student__c();
        this.listPagi = new List<WrapStudent>();
        this.getAllStudent();
    }

    /**
     * SearchStudent
     * Save student to database when get data from view
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    public void saveStudent()
    {

        loading = 'block';
        system.debug(insertStudent);
        insert insertStudent;
        insertStudent = new Student__c();
        searchStudent();
    }

    /**
     * goToUpdatePage
     * Get information of the student that you want to update
     * @param strId
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */    
    public void goToUpdatePage()
    {
        try 
        {
            strId = Apexpages.currentPage().getParameters().get('updateId');
            updateStudent = new Student__c();
            updateStudent = getDataById(strId);
        } 
        catch (Exception e) 
        {
            system.debug(e);
        }
        
    }

    /**
     * updateStudent
     * Update the student
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    public void updateStudent()
    {
        try 
        {
            update updateStudent;
            searchStudent();
        } 
        catch (Exception e) 
        {
            system.debug(e);
        }
        
    }

    /**
     * getDataById
     * Get information form database when have Id
     * @param id
     * @return 
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    @TestVisible
    private Student__c getDataById(String id)
    {
        try 
        {
            return
            [
                select 
                    StudentCode__c, 
                    FirstName__c, 
                    LastName__c, 
                    BirthDay__c, 
                    Sex__c, 
                    Class__c,
                    Class__r.ClassName__c
                from Student__c 
                where id=: id 
                limit 1
            ];
        } 
        catch (Exception e) 
        {
            return null;
        }
       
    }

    /**
     * deleteRow
     * Detele one row in table
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    public void deleteRow()
    {
        try 
        {
            loading = 'block';
            Database.delete(strDeleteId);
            strDeleteId = null;
            searchStudent();
        } 
        catch (Exception e) 
        {
            system.debug(e);
        }
        
    }


    public string loading {get; set;}

    /**
     * searchStudent
     * Search student, include 5 fields
     * @param 
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    public void searchStudent()
    {
        loading = 'block';
        // Fullname
         List<String> listFullName = new List<String>();
         // Set value
         String strSearchFullname = searchStudent.FullName__c;
         // Add to list
         listFullName.add('%'+strSearchFullname+'%');

         Date dtSearchDay = searchStudent.BirthDay__c;
         String strSearchClass = searchStudent.Class__c;
         String strSearchCode = searchStudent.StudentCode__c;
         String query = 'select FirstName__c, LastName__c, StudentCode__c, Sex__c, Class__c, Class__r.ClassName__c, BirthDay__c from Student__c ' +
         ' where FullName__c like: listFullName ';
        
            if (strSexTemp == 'Male')
            {   
                query += ' and Sex__c = true'; 
            }
            else if (strSexTemp == 'Female')
            {
                query += ' and Sex__c = false';
            }
        if (strSearchClass != '' && strSearchClass != null)
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

        listStudent = Database.query(query);

        listWrapStudents = new List<WrapStudent>();
        for (Student__c s : listStudent) 
        {
            listWrapStudents.add(new WrapStudent(s));
        }
        intCurrentPage = 1;
        pagiTable();
        loading = 'none';

    }
        
    // Get list of sex
    public List<SelectOption> listSex
    {
        get
        {
            List<SelectOption> listSexOptions = new List<SelectOption>();
            listSexOptions.add(new SelectOption('All','All'));
            listSexOptions.add(new SelectOption('Male','Male'));
            listSexOptions.add(new SelectOption('Female','Female'));
            return listSexOptions;
        }
        set;
    }

    /**
     * getAllStudent
     * List of all students
     * @param
     * @return listWrapStudents
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified
     */
    @TestVisible
    private List<WrapStudent> getAllStudent()
    {
        listStudent = [SELECT 
                            StudentCode__c, 
                            FirstName__c, 
                            LastName__c, 
                            BirthDay__c, 
                            Sex__c, 
                            Class__c,
                            Class__r.ClassName__c
                        FROM Student__c 
                        ];
        listWrapStudents = new List<WrapStudent>();
        for (Student__c s : listStudent) 
        {
            listWrapStudents.add(new WrapStudent(s));
        }
        intCurrentPage = 1;
        pagiTable();
        return listWrapStudents;
    }

    // Store list of class to show dropdown
    public List<SelectOption> listClass
    {
        get
        {
            listClassTemp = [
                Select
                    id,
                    ClassName__c 
                From Class__c
                ];
            
            listClass = new List<SelectOption>();
            listClass.add(new SelectOption( '','' ));
            for(Class__c c : listClassTemp)
            {
                listClass.add(new SelectOption(c.Id, c.ClassName__c));
            }
            return listClass;
        }
        set;
    }  
        
    /**
     * detailStudent
     * Get detail student
     * @param strId
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    public void detailStudent()
    {
        try 
        {
            strId = Apexpages.currentPage().getParameters().get('detailId');
            detailStudent =  getDataById(strId);
        } 
        catch (Exception e) 
        {
            system.debug(e);
        }
        
    } 

    // Count the number of page 
    public Integer intPageCount{get; set;}

    // The number of row display in a single page
    public Integer intPageSize{get; set;}

    // List of page in pagination
    public List<Integer> listPage{get; set;}

    // Store current page
    public Integer intCurrentPage{get; set;}

    // Store list of student in a every page
    public List<WrapStudent> listPagi{get; set;}


    /**
     * pagiTable
     * Get list student to show to in a single page
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    @TestVisible
    private void pagiTable()
    { 
        listPagi.clear();
        intPageCount = listWrapStudents.size()/intPageSize;
        if (math.mod(listWrapStudents.size(), intPageSize) != 0)
        {
            intPageCount = intPageCount + 1;
        }
        getListPage();
        if (intPageCount > 1)
        {
            for (integer i = (intCurrentPage - 1)*intPageSize; i<listWrapStudents.size() && i<(intCurrentPage*intPageSize);i++)
            {
                listPagi.add(listWrapStudents[i]);
            }
        }
        else if (intPageCount == 1)
        {
            listPagi = listWrapStudents;
        }

    }


    /**
     * changeCurrent
     * Change the ordinal of the page
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    public void changeCurrent()
    {
        system.debug(strListId);
        String str = Apexpages.currentPage().getParameters().get('page');

        if (intCurrentPage > intPageCount || intCurrentPage == intPageCount)
        {
            intCurrentPage = intPageCount;
        }
        if (intCurrentPage < 1)
        {
            intCurrentPage = 1;
        }
       
        for (WrapStudent w: listWrapStudents)
        {
            for (WrapStudent t: listPagi)
            {
                if (w.student == t.student)
                {
                    w.selected = t.selected;
                }
            }
        }

        getListPage();

        if (intPageCount == 1)
        {
            listPagi = listWrapStudents;
        }
        else if (intPageCount > 1)
        {
            listPagi.clear();
            for (integer i = (intCurrentPage - 1) * intPageSize; i < listWrapStudents.size() && i < (intCurrentPage * intPageSize); i++)
            {
                listPagi.add(listWrapStudents[i]);
            }
        }


    }

    /**
     * getListPage
     * Get list of page to show in pagination
     * @param
     * @return listPage
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    @TestVisible
    private List<Integer> getListPage()
    {
        listPage = new List<Integer>();
        
        if (intPageCount == 1 || intPageCount == 0)
        {
            listPage = null;
        }
        else if (intPageCount < 6)
        {
            for (integer i = 1; i<=intPageCount;i++)
            {
                listPage.add(i);
            }
        }
        else
        {
            if (intCurrentPage < 3)
            {
                listPage = new List<Integer>{1,2,3,4,5};
            }
            else if (intCurrentPage > intPageCount-2)
            {
                listPage = new List<Integer>{intPageCount-4,intPageCount-3,intPageCount-2,intPageCount-1,intPageCount};
            }
            else 
            {
                listPage = new List<Integer>{intCurrentPage-2,intCurrentPage-1, intCurrentPage, intCurrentPage+1,intCurrentPage+2};
            }
        }
        return listPage;
        
    }

    
    /**
    * Class name        : WrapStudent
    * Class description : Include student and a field named selected
    * @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
    * @modified         : 2023/07/03
     */
    public class WrapStudent 
   {
        public Student__c student {get; set;}
        public boolean selected {get; set;}
        public WrapStudent(Student__c student) 
        {
            this.student = student;
            selected = false; //If you want all checkboxes initially selected, set this to true
    	}
	}

    // List of all student in wrap class
    @TestVisible
    private List<WrapStudent> listWrapStudents {get; set;}

    // List of checked student
    @TestVisible
	private List<Student__c> listSelectedStudents {get; set;}


     /**
     * getStudents
     * Add all students to list wrap class
     * @param
     * @return students
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    @TestVisible
    private List<WrapStudent> getStudents() 
    {

        listWrapStudents = new List<WrapStudent>();
        for (Student__c s : [SELECT StudentCode__c, FirstName__c, LastName__c, BirthDay__c, Sex__c, Class__c FROM Student__c ]) 
        {
            listWrapStudents.add(new WrapStudent(s));
        }
        system.debug(listWrapStudents);
        return listWrapStudents;
    }

    // List of Id to delete
    public list<string> listId{get; set;}

     /**
     * selectedStudents
     * Delete selected students
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */
    public void selectedStudents() 
    {
        for (WrapStudent w: listWrapStudents)
        {
            for (WrapStudent t: listPagi)
            {
                if (w.student == t.student)
                {
                    w.selected = t.selected;
                }
            }
        }
        listId = new List<String>();
        listSelectedStudents = new List<Student__c>();
        for (WrapStudent w : listWrapStudents) 
        {
            if (w.selected == true) 
            {
                listSelectedStudents.add(w.student);
                listId.add(w.student.id);
                Database.delete(w.student.id);
            }
        }
        searchStudent();
    }
}