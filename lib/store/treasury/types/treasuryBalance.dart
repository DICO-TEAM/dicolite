class TreasuryBalance {
    String accountId="";
		int accountNonce=0;
		String freeBalance="";
		int frozenFee=0;
		int frozenMisc=0;
		int reservedBalance=0;
		String votingBalance="";

    TreasuryBalance();

    TreasuryBalance.fromJson(Map data) {
      this.accountId = data['accountId'];
      this.accountNonce = data['accountNonce'];
      this.freeBalance = data['freeBalance'].toString();
      this.frozenFee = data['frozenFee'];
      this.frozenMisc = data['frozenMisc'];
      this.reservedBalance = data['reservedBalance'];
      this.votingBalance = data['votingBalance'].toString();
    }
}