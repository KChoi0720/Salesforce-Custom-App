// public class MyAccountController {
//     public List<Account> accountList {get;set;}
    
//     public MyAccountController(){
// 		accountList = [select Id, Name from Account limit 100];
//     }
// }

public class MyAccountController {
    public List<Account> accountList {get;set;}
    
    public MyAccountController(){
		accountList = [select Id, Name, Website from Account where Website!=null limit 100 ];
    }
}