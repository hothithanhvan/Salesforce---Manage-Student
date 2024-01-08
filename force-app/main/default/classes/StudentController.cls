/**
* Class name        : StudentController
* Class description : 
* @created          : 2023/06/20 Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 
*/
public with sharing class StudentController 
{
    // Get information of insert student
    public Student__c insertStudent {get; set;}

    // Get list of student
    public list <Student__c> listStudent{get; set;}

    // Get Id to update
    public string strId{get; set;}

    // Get information of detail student
    public Student__c detailStudent{get; set;}

    // Get information of update student
    public Student__c updateStudent{get; set;}

    // Get information of class to display dropdown
    public List<Class__c> listClassTemp = new List<Class__c>();

    /**
     * StudentController
     * 
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
    public StudentController() 
    {
        this.updateStudent = new Student__c();
        this.detailStudent = new Student__c();
        this.insertStudent = new Student__c();
        this.setListStudent();

    }

    /**
     * saveStudent
     * Save the student of the input in view
     * @param
     * @return pageRef
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
    public Pagereference saveStudent()
    {
        insert insertStudent;
        PageReference pageRef = new PageReference('/apex/VF_DetailsStudent');
        pageRef.getParameters().put('id', insertStudent.Id);
        return pageRef;
    }

    
    /**
     * getListStudent
     * Get list of students
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
    private List <Student__c> getListStudent()
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
        ];
    }

    /**
     * setListStudent
     * Set list of students
     * @param
     * @return listStudent
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
    private List<Student__c> setListStudent()
    {
        listStudent = getListStudent();
        return listStudent;
    }

    /**
     * goToUpdatePage
     * Go to update page with information of the student that you want to update
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
    public void goToUpdatePage()
    {
        try 
        {
            strId = Apexpages.currentPage().getParameters().get('id');
            updateStudent = new Student__c();
            updateStudent = getDataById(strId);
        } 
        catch (Exception e) 
        {
            
        }
        
    }

    /**
     * updateStudent
     * Update the student you choose in a row
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
        } 
        catch (Exception e) 
        {
            
        }
    }

    /**
     * deleteStudent
     * Delete the student that have Id
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
    public void deleteStudent()
    {
        try 
        {
            Student__c student = getDataById(strId);
            system.debug(student);
            if (student != null)
            {
                database.delete(strId);
            }
            setListStudent();
        } catch (Exception e) 
        {
            system.debug(e);
        }
    }
    
    /**
     * getDataById
     * Get information from database when you have Id
     * @param id
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
    private Student__c getDataById(String id)
    {
        try 
        {
            Student__c student = [
                SELECT 
                    StudentCode__c, 
                    FirstName__c, 
                    LastName__c, 
                    BirthDay__c, 
                    Sex__c, 
                    Class__c,
                    Class__r.ClassName__c
                FROM Student__c 
                WHERE id=: id 
            ];
            return student;
        } 
        catch (Exception e) 
        {
            System.debug(e);
            return null;
        }
            
    }

    /**
     * detailStudent
     * Get detail of student
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
    public void detailStudent()
    {
        strId = Apexpages.currentPage().getParameters().get('id');
        detailStudent =  getDataById(strId);
    } 

    /**
     * listClass
     * Get list of class to show to view
     * @param
     * @return
     * @created: 2023/06/20 Ho Thi Thanh Van
     * @modified 
     */   
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
            
            for(Class__c temp : listClassTemp)
            {
                listClass.add(new SelectOption(temp.Id, temp.ClassName__c));
            }
            return listClass;
        }
        set;
    }
}