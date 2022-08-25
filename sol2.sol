// SPDX-License-Identifier: MIT

pragma solidity^0.8.7;

contract Invoice{

    struct invoiceInfo{
        uint invNo;
        string Date;
        uint Amount;
        string buyerPAN;
        string sellerPAN;
        bool paymentStatus;
        bool set;
        uint index;
    }

    invoiceInfo[] public invoiceinfo;
    mapping(string => uint[]) BPanToIndex;
    mapping(uint => uint) public InvoiceToIndex;

    function setInvoiceDetails(uint invNo, string calldata Date, uint Amount, string calldata buyerPAN, string calldata sellerPAN, bool paymentStatus) external {
        require(InvoiceToIndex[invNo] == 0,"this invoice is already set");
        uint index = invoiceinfo.length;
        invoiceinfo.push(invoiceInfo(invNo, Date, Amount, buyerPAN, sellerPAN, paymentStatus, true, index));
        BPanToIndex[buyerPAN].push(index);
        InvoiceToIndex[invNo] = index;
    }

    function getInvoiceDetails( string calldata buyerPAN) external view returns(invoiceInfo memory){
        uint i = 0;

        while(i<= BPanToIndex[buyerPAN].length){
            invoiceInfo memory data = invoiceinfo[BPanToIndex[buyerPAN][i]];
            i++;
            return data;
        }

    }

    function checkPaymentStatus( uint invNo) external view returns(bool ){
        return invoiceinfo[InvoiceToIndex[invNo]].paymentStatus;
    }

    function setPaymentStatus( uint invNo, bool status,) external {
        invoiceinfo[InvoiceToIndex[invNo]].paymentStatus = status;
    }

    //fallbackfunction
    receive() external payable{}
    fallback() external payable{}
}
