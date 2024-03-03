* @ValidationCode : MjozOTIxNDk4NjU6Q3AxMjUyOjE2NjE1NzU3MTQ2NzA6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Aug 2022 10:48:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>194</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE GB.JBL.A.MULTIPLE.MCD
*
*Retrofitted By:
*    Date         : 25/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.JBL.H.MUL.MCD
    $INSERT I_F.JBL.H.MUL.PRM
*
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Interface
    $USING EB.TransactionControl
    $USING EB.Foundation
*
    FN.MUL.PARAM='F.JBL.H.MUL.PRM'
    F.MUL.PARAM=''
    FN.MUL.MCD.NAU = 'FBNK.JBL.H.MUL.MCD$NAU'
    F.MUL.MCD.NAU = ''
*
    EB.DataAccess.Opf(FN.MUL.MCD.NAU,F.MUL.MCD.NAU)
    EB.DataAccess.Opf(FN.MUL.PARAM,F.MUL.PARAM)

    IF EB.SystemTables.getVFunction() EQ 'A' THEN
        Y.MUL.ID = EB.SystemTables.getIdNew()
        EB.DataAccess.FRead(FN.MUL.MCD.NAU,Y.MUL.ID,R.MUL.MCD.NAU,F.MUL.MCD.NAU,ERR.MUL.MCD.NAU)
     
        Y.DR.NO = R.MUL.MCD.NAU<MCD.DEBIT.ACCT.NO>
        Y.CR.NO = R.MUL.MCD.NAU<MCD.CREDIT.ACCT.NO>
        Y.DR.AMT = R.MUL.MCD.NAU<MCD.DEBIT.AMOUNT>
        Y.CR.AMT = R.MUL.MCD.NAU<MCD.CREDIT.AMOUNT>
        Y.DR.PAY.DET = R.MUL.MCD.NAU<MCD.DR.PAYMENT.DET>
        Y.CR.PAY.DET = R.MUL.MCD.NAU<MCD.CR.PAYMENT.DET>
        Y.CHQ.NUM = R.MUL.MCD.NAU<MCD.CHEQUE.NUMBER>
*
        EB.DataAccess.FRead(FN.MUL.PARAM,'SYSTEM',REC.MUL.PARAM,F.MUL.PARAM,ERR.MUL.PARAM)
        Y.ORD.BNK='JBL'
        Y.PRFT.DEP=REC.MUL.PARAM<MPM.PROFIT.CENTRE.DEPT>
        
        DR.AC.CNT=DCOUNT(Y.DR.NO,@VM)
        FOR yDrOfs=1 TO DR.AC.CNT
            Y.SUS.AC=EB.SystemTables.getLccy():REC.MUL.PARAM<MPM.SUS.CATEG>:"0001":RIGHT(EB.SystemTables.getIdCompany(),4)
            IF EB.SystemTables.getRNew(MCD.CHEQUE.NUMBER)<1,yDrOfs> EQ '' THEN
                Y.MESSAGE.DR="FUNDS.TRANSFER,JBL.ED/I/PROCESS//0,//":EB.SystemTables.getIdCompany():",,TRANSACTION.TYPE=AC,DEBIT.ACCT.NO=":Y.DR.NO<1,yDrOfs>:",DEBIT.CURRENCY=":EB.SystemTables.getLccy():",DEBIT.AMOUNT=":Y.DR.AMT<1,yDrOfs>:",DEBIT.VALUE.DATE=":EB.SystemTables.getToday():",CREDIT.ACCT.NO=":Y.SUS.AC:",ORDERING.BANK=":Y.ORD.BNK:",PROFIT.CENTRE.DEPT=":Y.PRFT.DEP:",IN.SWIFT.MSG=":Y.MUL.ID:",LT.FT.DR.DETAIL=":Y.DR.PAY.DET<1,yDrOfs>
            END
            ELSE
                Y.MESSAGE.DR="FUNDS.TRANSFER,JBL.ED/I/PROCESS//0,//":EB.SystemTables.getIdCompany():",,TRANSACTION.TYPE=AC,DEBIT.ACCT.NO=":Y.DR.NO<1,yDrOfs>:",DEBIT.CURRENCY=":EB.SystemTables.getLccy():",DEBIT.AMOUNT=":Y.DR.AMT<1,yDrOfs>:",DEBIT.VALUE.DATE=":EB.SystemTables.getToday():",CREDIT.ACCT.NO=":Y.SUS.AC:",ORDERING.BANK=":Y.ORD.BNK:",PROFIT.CENTRE.DEPT=":Y.PRFT.DEP:",CHEQUE.NUMBER=":EB.SystemTables.getRNew(MCD.CHEQUE.NUMBER)<1,yDrOfs>:",IN.SWIFT.MSG=":Y.MUL.ID:",LT.FT.DR.DETAIL=":Y.DR.PAY.DET<1,yDrOfs>
            END
            GOSUB DO.TRANSACTION.DR
        NEXT yDrOfs
    
        CR.AC.CNT=DCOUNT(Y.CR.NO,@VM)
        FOR yCrOfs=1 TO CR.AC.CNT
            Y.SUS.AC=EB.SystemTables.getLccy():REC.MUL.PARAM<MPM.SUS.CATEG>:"0001":RIGHT(EB.SystemTables.getIdCompany(),4)
            Y.MESSAGE.CR="FUNDS.TRANSFER,JBL.ED/I/PROCESS//0,//":EB.SystemTables.getIdCompany():",,TRANSACTION.TYPE=AC,DEBIT.ACCT.NO=":Y.SUS.AC:",DEBIT.CURRENCY=":EB.SystemTables.getLccy():",DEBIT.AMOUNT=":Y.CR.AMT<1,yCrOfs>:",DEBIT.VALUE.DATE=":EB.SystemTables.getToday():",CREDIT.ACCT.NO=":Y.CR.NO<1,yCrOfs>:",ORDERING.BANK=":Y.ORD.BNK:",PROFIT.CENTRE.DEPT=":Y.PRFT.DEP:",IN.SWIFT.MSG=":Y.MUL.ID:",LT.FT.CR.DETAIL=":Y.CR.PAY.DET<1,yCrOfs>
            GOSUB DO.TRANSACTION.CR
        NEXT yCrOfs
    END
RETURN

*------------------
DO.TRANSACTION.DR:
*------------------
    Y.DR.ACCOUNT.NO = Y.DR.NO<1,yDrOfs>
    Y.SOURCE="JBL.DM.OFS.SRC.VAL"
    EB.Interface.OfsCallBulkManager(Y.SOURCE,Y.MESSAGE.DR, theResponseDr, txnCommitted)
*EB.Interface.OfsBulkManager(Y.MESSAGE.DR, theResponseDr, txnCommitted)
*CALL ofs.addLocalRequest(Y.MESSAGE.DR,'APPEND',Y.ERR.OFS)
    Y.STATUS =''
    Y.STATUS =FIELD(FIELD(theResponseDr,"/",3,1),",",1)
    IF Y.STATUS EQ '1' THEN
        Y.DR.CNT = Y.DR.CNT + 1
        Y.DR.FT.REF = FIELD(FIELD(FIELD(theResponseDr,"/",1,1),",",1),">",3,1)
        IF Y.DR.FT.REF EQ '' THEN
            Y.DR.FT.REF = FIELD(FIELD(theResponseDr,"/",1,1),",",1)
        END
        GOSUB WRITE.DR.REF
    END
RETURN

*------------------
DO.TRANSACTION.CR:
*------------------
    Y.CR.ACCOUNT.NO = Y.CR.NO<1,yCrOfs>
    Y.SOURCE="JBL.DM.OFS.SRC.VAL"
*EB.Interface.OfsBulkManager(Y.MESSAGE.CR, theResponseCr, txnCommitted)
    EB.Interface.OfsCallBulkManager(Y.SOURCE,Y.MESSAGE.CR, theResponseCr, txnCommitted)
*CALL ofs.addLocalRequest(Y.MESSAGE.CR,'APPEND',Y.ERR.OFS)
    Y.STATUS =FIELD(FIELD(theResponseCr,"/",3,1),",",1)
    IF Y.STATUS EQ '1' THEN
        Y.CR.CNT = Y.CR.CNT + 1
        Y.CR.FT.REF =FIELD(FIELD(FIELD(theResponseCr,"/",1,1),",",1),">",3,1)
        IF Y.CR.FT.REF EQ '' THEN
            Y.CR.FT.REF =FIELD(FIELD(theResponseCr,"/",1,1),",",1)
        END
        GOSUB WRITE.CR.REF
    END
RETURN

*************
WRITE.DR.REF:
*************
    EB.DataAccess.FRead(FN.MUL.MCD.NAU,Y.MUL.ID,R.MUL.MCD.NAU,F.MUL.MCD.NAU,ERR.MUL.MCD.NAU)
    Y.DR.AC.LIST = R.MUL.MCD.NAU<MCD.DEBIT.ACCT.NO>
    LOCATE Y.DR.ACCOUNT.NO IN Y.DR.AC.LIST<1,1> SETTING Y.POS THEN NULL
    IF Y.POS NE '' THEN
        R.MUL.MCD.NAU<MCD.DR.FT.REF,Y.POS> = Y.DR.FT.REF
        R.MUL.MCD.NAU<MCD.DR.OFS.ERR.Y.N,Y.POS> = 'N'
        WRITE R.MUL.MCD.NAU ON F.MUL.MCD.NAU, Y.MUL.ID
        EB.TransactionControl.JournalUpdate('')
        SENSITIVITY=''
    END
RETURN

*************
WRITE.CR.REF:
*************
    EB.DataAccess.FRead(FN.MUL.MCD.NAU,Y.MUL.ID,R.MUL.MCD.NAU,F.MUL.MCD.NAU,ERR.MUL.MCD.NAU)
    Y.CR.AC.LIST = R.MUL.MCD.NAU<MCD.CREDIT.ACCT.NO>
    LOCATE Y.CR.ACCOUNT.NO IN Y.CR.AC.LIST<1,1> SETTING Y.POS THEN NULL
    IF Y.POS NE '' THEN
        R.MUL.MCD.NAU<MCD.CR.FT.REF,Y.POS> = Y.CR.FT.REF
        R.MUL.MCD.NAU<MCD.CR.OFS.ERR.Y.N,Y.POS> = 'N'
        WRITE R.MUL.MCD.NAU ON F.MUL.MCD.NAU, Y.MUL.ID
        EB.TransactionControl.JournalUpdate('')
        SENSITIVITY=''
    END
RETURN
END