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
    }

    invoiceInfo[] public invoiceinfo;
    mapping(string => invoiceInfo[]) BPanToInvoice;
    mapping(uint => invoiceInfo) InvoiceToDetails;

    function setInvoiceDetails(uint invNo, string calldata Date, uint Amount, string calldata buyerPAN, string calldata sellerPAN, bool paymentStatus) external {

        require(InvoiceToDetails[invNo].set == false,"already set");
        BPanToInvoice[buyerPAN].push(invoiceInfo(invNo, Date, Amount, buyerPAN, sellerPAN, paymentStatus, true));
        InvoiceToDetails[invNo] = invoiceInfo(invNo, Date, Amount, buyerPAN, sellerPAN, paymentStatus, true);
        invoiceinfo.push(invoiceInfo(invNo, Date, Amount, buyerPAN, sellerPAN, paymentStatus, true));
    }

    function getInvoiceDetails( string calldata buyerPAN) external view returns(invoiceInfo[] memory){
        return BPanToInvoice[buyerPAN];
    }

    function checkPaymentStatus( uint invNo) external view returns(bool){
        return InvoiceToDetails[invNo].paymentStatus;
    }

    function setPaymentStatus( uint invNo, bool status) external returns(invoiceInfo memory){
        InvoiceToDetails[invNo].paymentStatus = status;
        return InvoiceToDetails[invNo];
    }

    //fallbackfunction
    receive() external payable{}
    fallback() external payable{}
}

