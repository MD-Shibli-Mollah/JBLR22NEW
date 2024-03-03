*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.V.DD.ISSUE.RTN

*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING TT.Contract
    $USING FT.Contract
    $USING EB.LocalReferences
    $USING EB.SystemTables
    $USING EB.Updates
    $INSERT I_F.EB.JBL.H.DD.DETAILS

    FN.DD.DETAILS ='F.EB.JBL.H.DD.DETAILS'
    F.DD.DETAILS=''
    EB.DataAccess.Opf(FN.DD.DETAILS, F.DD.DETAILS)

    Y.APP.NAME='FUNDS.TRANSFER' : FM : 'TELLER'
    Y.LOCAL.FIELDS='LT.COMPANY' : VM : 'LT.PR.CHEQUE.N': VM : 'LT.DD.TT.MT':VM:'LT.SCROLL':FM: 'LT.COMPANY': VM : 'LT.PR.CHEQUE.N': VM : 'LT.DD.TT.MT':VM:'LT.SCROLL'
    EB.Updates.MultiGetLocRef(Y.APP.NAME, Y.LOCAL.FIELDS, Y.FIELDS.POS)
   
    Y.BR.CODE.POS.FT = Y.FIELDS.POS<1,1>
    Y.PR.CHQ.POS.FT=Y.FIELDS.POS<1,2>
    Y.DD.TT.MT.POS.FT = Y.FIELDS.POS<1,3>
    Y.SCROLL.POS.FT = Y.FIELDS.POS<1,4>
    
    Y.BR.CODE.POS.TT = Y.FIELDS.POS<2,1>
    Y.PR.CHQ.POS.TT=Y.FIELDS.POS<2,2>
    Y.DD.TT.MT.POS.TT = Y.FIELDS.POS<2,3>
    Y.SCROLL.POS.TT = Y.FIELDS.POS<2,4>
    
    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        Y.DD.DETAILS.ID =EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.DD.TT.MT.POS.TT>:".":RIGHT(EB.SystemTables.getIdCompany(),4):".":RIGHT(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.BR.CODE.POS.TT>,4):".":EB.SystemTables.getToday()[1,4]:".":EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.SCROLL.POS.TT>
        
        REC.DD.DETAILS<EB.JBL32.DATE.OF.ISSUE>=EB.SystemTables.getRNew(TT.Contract.Teller.TeValueDateOne)
        REC.DD.DETAILS<EB.JBL32.INS.PRINTED.NO>=EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.PR.CHQ.POS.TT>
        REC.DD.DETAILS<EB.JBL32.BENIFICIARY>=EB.SystemTables.getRNew(TT.Contract.Teller.TeTheirReference)
        REC.DD.DETAILS<EB.JBL32.PURCHASER>=EB.SystemTables.getRNew(TT.Contract.Teller.TeNarrativeTwo)
        REC.DD.DETAILS<EB.JBL32.AMOUNT>=EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
        REC.DD.DETAILS<EB.JBL32.ISSUE.REF.NO>=EB.SystemTables.getIdNew()
        REC.DD.DETAILS<EB.JBL32.INS.TYPE> =EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.DD.TT.MT.POS.TT>
        REC.DD.DETAILS<EB.JBL32.INS.PAID>='N'
        REC.DD.DETAILS<EB.JBL32.ADVICE>='N'
        REC.DD.DETAILS<EB.JBL32.INPUTTER>=EB.SystemTables.getRNew(TT.Contract.Teller.TeInputter)
    END


    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        Y.DD.DETAILS.ID =EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.DD.TT.MT.POS.FT>:".":RIGHT(EB.SystemTables.getIdCompany(),4):".":RIGHT(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.BR.CODE.POS.FT>,4):".":EB.SystemTables.getToday()[1,4]:".":EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.SCROLL.POS.FT>

        REC.DD.DETAILS<EB.JBL32.DATE.OF.ISSUE> =EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitValueDate)
        REC.DD.DETAILS<EB.JBL32.INS.PRINTED.NO> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.PR.CHQ.POS.FT>
        REC.DD.DETAILS<EB.JBL32.BENIFICIARY> =EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
        REC.DD.DETAILS<EB.JBL32.PURCHASER>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditTheirRef)
        REC.DD.DETAILS<EB.JBL32.AMOUNT> =EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        REC.DD.DETAILS<EB.JBL32.ISSUE.REF.NO> = EB.SystemTables.getIdNew()
        REC.DD.DETAILS<EB.JBL32.INS.TYPE> =EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.DD.TT.MT.POS.FT>
        REC.DD.DETAILS<EB.JBL32.INS.PAID>='N'
        REC.DD.DETAILS<EB.JBL32.ADVICE>='N'
        REC.DD.DETAILS<EB.JBL32.INPUTTER>=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.Inputter)
    END
    REC.DD.DETAILS<EB.JBL32.CO.CODE>=EB.SystemTables.getIdCompany()
    WRITE REC.DD.DETAILS TO F.DD.DETAILS,Y.DD.DETAILS.ID


RETURN
END