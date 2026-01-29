public with sharing class MyAccountController {

    public List<SalesRow> salesList { get; set; }

    public MyAccountController() {
        salesList = new List<SalesRow>();

        List<OpportunityLineItem> items = [
            SELECT Id,
                   Quantity,
                   TotalPrice,
                   PricebookEntry.Product2.Name
            FROM OpportunityLineItem
            LIMIT 10
        ];

        for (OpportunityLineItem i : items) {
            Decimal revenue = i.TotalPrice == null ? 0 : i.TotalPrice;
            Decimal cost = 0;      // 如果你没有成本字段，先写死 0
            Decimal profit = revenue - cost;

            salesList.add(new SalesRow(
                i.PricebookEntry.Product2.Name,
                i.Quantity,
                revenue,
                cost,
                profit
            ));
        }
    }

    // ===== Wrapper =====
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
