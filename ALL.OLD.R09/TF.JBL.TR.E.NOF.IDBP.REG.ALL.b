SUBROUTINE TF.JBL.TR.E.NOF.IDBP.REG.ALL(Y.RETURN)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON
    $USING AA.Framework
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING  ST.CompanyCreation
    $USING AA.Account
    $USING AA.TermAmount
    $USING EB.Updates
    $USING  LC.Contract
*    $USING  RE.ConBalanceUpdates
		$USING  BF.ConBalanceUpdates
    $USING ST.Config
    $USING EB.API
    $USING EB.Foundation
    $USING EB.Reports
    
    ! ST.CompanyCreation.LoadCompany('BNK')


    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    EB.DataAccess.Opf(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
    
    FN.DR='F.DRAWINGS'
    F.DR=''
    EB.DataAccess.Opf(FN.DR,F.DR)
    
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
      
  
    LOCATE 'FROM.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.POS THEN
        Y.FROM.DATE =  EB.Reports.getEnqSelection()<4,FROM.POS>
        EB.API.Juldate(Y.FROM.DATE, Y.FROM.JUL)
        Y.FROM.JUL = Y.FROM.JUL[3,5]
    END
    
    LOCATE 'TO.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.POS THEN
        Y.TO.DATE =  EB.Reports.getEnqSelection()<4,FROM.POS>
        EB.API.Juldate(Y.TO.DATE, Y.TO.JUL)
        Y.TO.JUL = Y.TO.JUL[3,5]
    END
    
    
      
    !LOCATE 'BENEFICIARY.CUSTNO' IN EB.Reports.getEnqSelection()<2,1> SETTING BENEFICIARY.CUSTNO.POS THEN
    !    Y.CUS.ID =  EB.Reports.getEnqSelection()<4,BENEFICIARY.CUSTNO.POS>
    ! END
    
      
    
    Y.FIELDS = ""
    Y.APPLICATION = "AA.ARR.ACCOUNT"
    Y.FIELDS = "LT.LN.BIL.DOCVL":VM:"LINKED.TFDR.REF":VM:"LT.TF.EXCH.RATE":VM:"LT.LN.PUR.FCAMT":VM:"LT.LEGACY.ID"
    EB.Updates.MultiGetLocRef(Y.APPLICATION, Y.FIELDS, Y.POS)
    Y.BILL.DOC.VALUE.POS = Y.POS<1,1>
    Y.LINKED.TFDR.REF.POS = Y.POS<1,2>
    Y.EXC.RATE.POS  = Y.POS<1,3>
    Y.PUR.FCAMT.POS = Y.POS<1,4>
    Y.BANK.REF.POS = Y.POS<1,5>

     
    Y.CO.CODE =''
    !  Y.CO.CODE= ID.COMPANY
    Y.PRODUCT.GROUP = 'JBL.IDBP.LN'
    Y.PROP.CLASS =''
    Y.PROPERTY =''
    IF (Y.FROM.JUL EQ '' AND Y.TO.JUL EQ '') THEN
        SEL.CMD= " SELECT " :FN.AA.ARRANGEMENT : " WITH PRODUCT.GROUP EQ " : Y.PRODUCT.GROUP
    END
    ELSE IF ( Y.FROM.JUL NE '' AND Y.TO.JUL NE '') THEN
        SEL.CMD= " SELECT " :FN.AA.ARRANGEMENT : " WITH PRODUCT.GROUP EQ " : Y.PRODUCT.GROUP :" AND  START.DATE GE " : Y.FROM.JUL : " AND  START.DATE LE " : Y.TO.JUL
    END
    
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.NO)
    LOOP
        REMOVE Y.ARR.ID FROM SEL.LIST SETTING Y.POS
    WHILE Y.ARR.ID:Y.POS
        PRINT Y.ARR.ID
        AA.Framework.GetArrangement(Y.ARR.ID, R.ARRANGEMENT, E.ARRANGEMENT)
        Y.VALUE.DATE= R.ARRANGEMENT<AA.Framework.Arrangement.ArrStartDate>
        Y.CURRENCY = R.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency>
        ! Y.BRANCH =   R.ARRANGEMENT<AA.Framework.Arrangement.ArrCoCode>
        !Y.BRANCH= ''
        Y.PROP.CLASS = 'ACCOUNT'
        Y.PROPERTY= 'ACCOUNT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,Y.PROP.CLASS,Y.PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
        R.REC = RAISE(RETURN.VALUES)
        ! PRINT R.REC
        Y.CATEGORY = R.REC<AA.Account.Account.AcCategory>
        !   IF Y.CATEGORY NE Y.USER.CATEGORY THEN CONTINUE
        Y.ACCOUNT =  R.REC<AA.Account.Account.AcAccountReference>
        Y.CO.CODE = R.REC<AA.Account.Account.AcCoCode>
        Y.ACCOUNT.LT = R.REC<AA.Account.Account.AcLocalRef>
        ! PRINT "LOCAL TABLE ": Y.ACCOUNT.LT
        Y.BILL.DOC.VALUE = Y.ACCOUNT.LT<1,Y.BILL.DOC.VALUE.POS>
        Y.LINKED.TFDR.REF = Y.ACCOUNT.LT<1,Y.LINKED.TFDR.REF.POS>
        Y.EXC.RATE = Y.ACCOUNT.LT<1,Y.EXC.RATE.POS>
        Y.PUR.FCAMT = Y.ACCOUNT.LT<1,Y.PUR.FCAMT.POS>
        Y.BANK.REF = Y.ACCOUNT.LT<1,Y.BANK.REF.POS>
        
        
                
        R.EB.CONTRACT.BALANCES = ''
        YERR = ''
        EB.DataAccess.FRead(FN.EB.CONTRACT.BALANCES, Y.ACCOUNT,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,YERR)
       
*        Y.CURR.ASSET.TYPE = R.EB.CONTRACT.BALANCES<RE.ConBalanceUpdates.EbContractBalances.EcbCurrAssetType>
*        Y.DEBIT.MVMT.LIST = R.EB.CONTRACT.BALANCES<RE.ConBalanceUpdates.EbContractBalances.EcbDebitMvmt>
*        Y.CREDIT.MVMT.LIST = R.EB.CONTRACT.BALANCES<RE.ConBalanceUpdates.EbContractBalances.EcbCreditMvmt>
        
        Y.CURR.ASSET.TYPE = R.EB.CONTRACT.BALANCES<BF.ConBalanceUpdates.EbContractBalances.EcbCurrAssetType>
        Y.DEBIT.MVMT.LIST = R.EB.CONTRACT.BALANCES<BF.ConBalanceUpdates.EbContractBalances.EcbDebitMvmt>
        Y.CREDIT.MVMT.LIST = R.EB.CONTRACT.BALANCES<BF.ConBalanceUpdates.EbContractBalances.EcbCreditMvmt>        
        
        Y.CURR.ASSET.TYPE.COUNT = DCOUNT(Y.CURR.ASSET.TYPE, VM)
        FOR I = 1 TO Y.CURR.ASSET.TYPE.COUNT
            IF Y.CURR.ASSET.TYPE<1,I> EQ 'CURACCOUNT' THEN
                Y.DEBIT.MVMT = Y.DEBIT.MVMT.LIST<1,I>
                Y.CREDIT.MVMT = Y.CREDIT.MVMT.LIST<1,I>
                Y.BALACE = Y.DEBIT.MVMT + Y.CREDIT.MVMT
                
          
            END
        NEXT I
        
        Y.DR.ID =Y.LINKED.TFDR.REF
        EB.DataAccess.FRead(FN.DR,Y.DR.ID,R.DR.REC,F.DR,DR.ERR)
        !  PRINT "DRAWING DETAILS ": R.DR.REC
        Y.DOCUMENT.CUR=R.DR.REC<LC.Contract.Drawings.TfDrDrawCurrency>
        ! PRINT "DOC CUR": Y.DOCUMENT.CUR
        Y.PROP.CLASS = 'TERM.AMOUNT'
        Y.PROPERTY= 'COMMITMENT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,Y.PROP.CLASS,Y.PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
        R.REC = RAISE(RETURN.VALUES)
        ! PRINT R.REC
        Y.MATURITY.DATE = R.REC<AA.TermAmount.TermAmount.AmtMaturityDate>
        Y.TERM.AMOUNT = R.REC<AA.TermAmount.TermAmount.AmtAmount>
        !PRINT Y.MATURITY.DATE
        !PRINT Y.TERM.AMOUNT
                
        Y.RETURN<-1> = Y.ARR.ID:'*':Y.VALUE.DATE:'*':Y.CURRENCY:'*':Y.TERM.AMOUNT:'*':Y.MATURITY.DATE:'*':Y.DOCUMENT.CUR:'*':Y.BILL.DOC.VALUE:'*':Y.EXC.RATE:'*':Y.PUR.FCAMT:'*':Y.BANK.REF:'*': Y.CO.CODE :'*': Y.BALACE
        !PRINT Y.RETURN
    REPEAT
END

END
