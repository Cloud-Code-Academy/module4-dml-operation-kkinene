/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Katende Kinene
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount= new Account(Name='Salesforce Sherpa', Phone='678-379-7135');

        // Set some fields on the Account

        // Insert the Account into the database
        insert newAccount;
        // Return the Id of the newly created Account
        return newAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account newAccount= new Account(Name=name, Industry=industry);
        // Insert the Account
        insert newAccount;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact= new Contact(FirstName='Katende', LastName='Kinene');
        // Set some fields on the Contact
        newContact.Title='Salesforce Certified Professional';
        // Set the AccountId field to the given accountId
        newContact.AccountId= accountId;
        // Insert the Contact into the database
        insert newContact;
        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        //List<Contact> myContacts =[SELECT Id FROM Contact WHERE Id = :contactId];
        Contact contactToBeUpdated=  [SELECT Id FROM Contact WHERE Id = :contactId];//myContacts[0];

        // Update the Contact's last name
        contactToBeUpdated.LastName= newLastName;
        // Update the Contact in the database
        update contactToBeUpdated;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity oppToBeUpdated=[SELECT Id FROM Opportunity WHERE Id = :oppId];
        // Update the Opportunity's stage
        oppToBeUpdated.StageName=newStage;
        oppToBeUpdated.CloseDate=Date.today().addYears(3);
        // Update the Opportunity in the database
        update oppToBeUpdated;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        account actToBeUpdated=  [SELECT Id FROM Account WHERE Id = :accountId] ;
        // Update the Account with the given Id with the new name and industry
        actToBeUpdated.Name= newName;
        actToBeUpdated.Industry= newIndustry;
        update actToBeUpdated;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        for(Opportunity temp: opportunities){
            // Set the Opportunity's Stage to Qualification
            temp.StageName='Qualification';
            // Set the Opportunity's Close Date to 3 months from today
            temp.CloseDate=Date.today().addMonths(3);
            // Set the Opportunity's Amount to 50000
            temp.Amount = 50000;
        }
            
        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        Account newAccount= new Account(Name=AccountName, Industry='Consulting');
        upsert newAccount;
        String newAccountId=newAccount.Id;

        // Loop through each Opportunity name
        List <Opportunity> oppList = new List <Opportunity>();
        for(Integer count= 0;count<oppNames.size();count+=1){
            // Create an Opportunity with the given name
            Opportunity temp = new Opportunity(AccountId=newAccountId, Name=oppNames[count], StageName = 'Prospecting', CloseDate = Date.today().addYears(2));
            // Add the Opportunity to the list
            oppList.add(temp);
        }
        if (!oppList.isEmpty()){
            upsert oppList;
        }
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];

		// if the Account exists, update the description
        if(!accounts.isEmpty()){//accounts!=null did not work
            Account accountToUpdate= accounts[0];
            accountToUpdate.Description='Updated Account';
            update accountToUpdate;
            return accountToUpdate;

        }else{
		// otherwise, create a new Account and set the description
        Account newAccount = new Account(Name = accountName, Industry = 'Consulting');
        newAccount.Description = 'New Account';
        // Upsert the Account
        upsert newAccount;
        return newAccount;

        }

	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact
        String contactLastName='';
        //Account accountToUpdate;
        List <Contact> contactList = new List <Contact>();
        for(Contact tempContact: contactsToUpsert){
		    // Extract the Account Name from Contact's LastName
            contactLastName = tempContact.LastName;
            // Get the account based on the name or create one if it doesn't exist
            List<Account> accounts = [SELECT Id FROM Account WHERE Name = :contactLastName] ;
            
            if(!accounts.isEmpty()){//Returns False if you have accounts in the list
                Account accountToUpdate = accounts[0];
                // Link the Contact to its Account using the Account Id
      			tempContact.AccountId = accountToUpdate.Id;
            }else {//Account does not exits
                Account newAccount = new Account(Name = contactLastName);
                insert newAccount;
                tempContact.AccountId = newAccount.Id;
            }
           
            contactList.add(tempContact); 
        }
        // Upsert the Contacts
        if(!contactList.isEmpty()){
            upsert contactList;
        }
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {//Integer[] numbers = new Integer[] {1, 2, 3};
        //Lead[] leadList= new Lead[]{};//This is fixed as empty and cannot be dynamically increased. I don't understand why ?
        List<Lead> leadList = new List<Lead>();
        // Loop through each Lead name
        for(String tempLead: leadNames){
            // Insert the Leads
           // leadList.add(tempLead);   
           Lead lead = new Lead();
           lead.LastName = tempLead;
           leadList.add(lead);
        }
        // Delete the Leads
        //You can also clear a list be re-initializing it like this: 
        leadList = new List<Lead>();
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        Case[] tempCase = new Case[numOfCases];
        for(Integer count = 0; count < numOfCases;count++){
            tempCase[count] = new Case();//I am confused as to why I have to do this, why didn't the declaring the array already take care of this ?
            tempCase[count].AccountId = accountId;
            tempCase[count].Status = 'New';
            tempCase[count].Origin = 'Email';         

        }
        //System.debug('tempCase size ='+tempCase.size());
        Database.insert(tempCase);//Gemini to the rescue

        // Delete the cases
        
        Database.delete(tempCase, true);
        //System.debug('tempCase size after delete ='+tempCase.size());

        tempCase = new List<Case>();//re-initialize the Case
    }
}