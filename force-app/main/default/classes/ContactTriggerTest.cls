@isTest
public class ContactTriggerTest {
    
    @TestSetup
    static void makeData(){
        Account a = new Account();
        a.Name = 'TestAccount1';
        insert a;

        Contact c1 = new Contact();
        c1.AccountId = a.Id;
        c1.LastName = 'TestContact1';
        insert c1;

        Contact c2 = new Contact();
        c2.AccountId = NULL;
        c2.LastName = 'TestContact2';
        insert c2;
           
    }

    @isTest
    public static void testContactTrigger(){
        List<Account> accList = [Select Id, Name, Contact_Count__c From Account];
        List<Contact> conList = [Select Id, LastName, AccountId From Contact];
        List<Contact> conWoAccId = [Select Id, AccountId From Contact Where AccountId = NULL];

        Integer cc = Integer.valueOf(accList[0].Contact_Count__c);

        System.assertEquals(1, accList.size());
        System.assertEquals(1, cc);
        System.assertEquals(NULL, conWoAccId[0].AccountId);
        
        Test.startTest();

        conWoAccId[0].AccountId = accList[0].Id;
        update conWoAccId;                   

        Test.stopTest();

        System.assertNotEquals(NULL, conWoAccId[0].AccountId);



    }

}
