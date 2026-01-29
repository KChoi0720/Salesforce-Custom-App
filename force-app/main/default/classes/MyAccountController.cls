public with sharing class MyAccountController {

    public List<SalesRow> salesList { get; set; }

    public MyAccountController() {
        salesList = new List<SalesRow>();

        List<OpportunityLineItem> items = [
            SELECT Id,
                   Quantity,
                   TotalPrice,
                   PricebookEntry.Product2.Name,
                   Cost__c
            FROM OpportunityLineItem
            LIMIT 20
        ];

        for (OpportunityLineItem i : items) {
            Decimal cost = i.Cost__c == null ? 0 : i.Cost__c;
            Decimal profit = i.TotalPrice - cost;

            salesList.add(new SalesRow(
                i.PricebookEntry.Product2.Name,
                i.Quantity,
                i.TotalPrice,
                cost,
                profit
            ));
        }
    }

    // Wrapper class
    public class SalesRow {
        public String productName { get; set; }
        public Decimal quantity { get; set; }
        public Decimal revenue { get; set; }
        public Decimal cost { get; set; }
        public Decimal profit { get; set; }

        public SalesRow(String p, Decimal q, Decimal r, Decimal c, Decimal pr) {
            productName = p;
            quantity = q;
            revenue = r;
            cost = c;
            profit = pr;
        }
    }
}
