public class MyControllerExtension {

    private final Account acct;
    //The extension constructor initializes the private member
    //variable acct by using the getRecord method from the standard controller
    
    public MyControllerExtension(ApexPages.StandardController stdController){
        this.acct = (Account)stdController.getRecord();
    }
    
    public String getGreetings(){
        return 'Hello' + acct.name + ' (' + acct.id + ')';
    }
    
}