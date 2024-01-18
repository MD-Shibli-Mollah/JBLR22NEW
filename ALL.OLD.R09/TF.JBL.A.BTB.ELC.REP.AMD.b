* @ValidationCode : Mjo2ODEyMzAxNzE6Q3AxMjUyOjE1NzQxNzAxNTY0NTc6REVMTDotMTotMTowOjA6ZmFsc2U6Ti9BOlIxN19BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Nov 2019 19:29:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.A.BTB.ELC.REP.AMD
*-----------------------------------------------------------------------------
* This routine is used to update Sales Contract and JOB Register Information
* during ELC Replace Amendment record authorization
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    $INSERT I_F.BD.BTB.JOB.REGISTER
*-----------------------------------------------------------------------------
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.SystemTables

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    FN.LC = 'F.LETTER.OF.CREDIT';           F.LC = ''
    FN.SCT = 'F.BD.SCT.CAPTURE';            F.SCT = ''
    FN.BTB.JR = 'F.BD.BTB.JOB.REGISTER';    F.BTB.JR = ''
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.SCT,F.SCT)
    EB.DataAccess.Opf(FN.BTB.JR,F.BTB.JR)

    APP.NAME = 'LETTER.OF.CREDIT'
    LOCAL.FIELDS = 'LT.TF.JOB.NUMBR':VM:'LT.TF.SCONT.ID':VM:'LT.TF.CONT.RAMT':VM:'LT.TF.FULL.REP':VM:'LT.TF.JOB.EX.RT':VM:'LT.TF.BTB.ENTAM':VM:'LT.TF.PC.ENT.AM'
    EB.Foundation.MapLocalFields(APP.NAME, LOCAL.FIELDS, FLD.POS)
RETURN

********
PROCESS:
********
    GOSUB VARIABLE.ASSIGN
    GOSUB GET.LOC.REF.POS
* find RNew and RNewLast Local reference field value for current LC
    Y.LC.LOC.REF= EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.LC.LOC.REF.POS= LC.Contract.LetterOfCredit.TfLcLocalRef
    Y.LC.LOC.REF.RNEW.LST = EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.LC.LOC.REF.ROLD.LST = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)

* update Sales Contract record
    Y.SCT.ID.LST = Y.LC.LOC.REF<1,Y.TF.SCONT.ID.POS>
    Y.SCT.ID.CNT = DCOUNT(Y.LC.LOC.REF<1,Y.TF.SCONT.ID.POS>,SM)
    FOR I = 1 TO Y.SCT.ID.CNT
        Y.TF.SCONT.ID = FIELD(Y.SCT.ID.LST,SM,I)
        EB.DataAccess.FRead(FN.SCT,Y.TF.SCONT.ID,R.SCT.REC,F.SCT,SCT.ERR)
        GOSUB UPDATE.SCT.REC
    NEXT I

* update JOB Register Record
    GOSUB UPDATE.JOB.REGISTER
RETURN

***************
UPDATE.SCT.REC:
***************
    Y.SCT.CONT.AMT.USE = R.SCT.REC<SCT.CONTRACT.USE.AMT>
    Y.SCT.CONT.AMT.NAU = R.SCT.REC<SCT.CONTRACT.AMT.NAU>
    Y.SCT.AVAIL.AMT = R.SCT.REC<SCT.CONTRACT.AVAIL.AMT>
    Y.TF.FULL.REP.YN = Y.LC.LOC.REF<1,Y.TF.FULL.REP.POS,I>
    Y.TF.CONT.RAMT = Y.LC.LOC.REF<1,Y.TF.CONT.RAMT.POS,I>
    Y.TF.CONT.RAMT.RNEW.LAST = Y.LC.LOC.REF.RNEW.LST<1,Y.TF.CONT.RAMT.POS,I>
    Y.TF.CONT.RAMT.ROLD = Y.LC.LOC.REF.ROLD.LST<1,Y.TF.CONT.RAMT.POS,I>
    
* calculate total entitlement Amt for only replaced SCT Amt entered in ELC Replacement
    GOSUB CALC.REPLACED.SCT.ENT.AMT ;*NEED TO REMOVE THIS GOSUB AFTER DETAILS CHECKING
    R.SCT.REC<SCT.CONTRACT.AMT.NAU> = Y.SCT.CONT.AMT.NAU - (Y.TF.CONT.RAMT - Y.TF.CONT.RAMT.ROLD)
    R.SCT.REC<SCT.CONTRACT.USE.AMT> = Y.SCT.CONT.AMT.USE + (Y.TF.CONT.RAMT - Y.TF.CONT.RAMT.ROLD)

* update Replace ELC Ref No, Replacement Date and Covered Amt to Sales Contract
    Y.REP.ELC.REFNO = EB.SystemTables.getIdNew()
    Y.REP.ELC.REFNO.LST = R.SCT.REC<SCT.REP.ELC.NO>
    LOCATE Y.REP.ELC.REFNO IN Y.REP.ELC.REFNO.LST SETTING REP.ELC.REFNO.POS  THEN
        R.SCT.REC<SCT.REP.ELC.DATE,REP.ELC.REFNO.POS> = TODAY
        R.SCT.REC<SCT.ELC.COVERED.AMT,REP.ELC.REFNO.POS> = Y.TF.CONT.RAMT
    END ELSE
        Y.REP.ELC.REFNO.CNT = DCOUNT(R.SCT.REC<SCT.REP.ELC.NO>,@VM) + 1
        R.SCT.REC<SCT.REP.ELC.NO,Y.REP.ELC.REFNO.CNT> = EB.SystemTables.getIdNew()
        R.SCT.REC<SCT.REP.ELC.DATE,Y.REP.ELC.REFNO.CNT> = TODAY
        R.SCT.REC<SCT.ELC.COVERED.AMT,Y.REP.ELC.REFNO.CNT> = Y.TF.CONT.RAMT
    END

* update SCT.FULLY.REPLACE.YN flag based on Available Amount
    IF Y.SCT.AVAIL.AMT LE '0' THEN
        R.SCT.REC<SCT.FULLY.REPLACE.YN> = 'YES'
    END ELSE
        R.SCT.REC<SCT.FULLY.REPLACE.YN> = 'NO'
    END

* update Sales Contract audit information
    R.SCT.REC<SCT.INPUTTER> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcInputter)
    R.SCT.REC<SCT.AUTHORISER> = EB.SystemTables.getOperator()
    R.SCT.REC<SCT.CO.CODE> = EB.SystemTables.getIdCompany()

    WRITE R.SCT.REC ON F.SCT,Y.TF.SCONT.ID
RETURN

**************************
CALC.REPLACED.SCT.ENT.AMT:
**************************
    Y.SCT.CONT.AMT = R.SCT.REC<SCT.CONTRACT.AMT>
    Y.SCT.BTB.ENT.RATE = R.SCT.REC<SCT.BTB.ENT.RATE>
    Y.SCT.PCECC.ENT.RATE = R.SCT.REC<SCT.PCECC.ENT.RATE>
    Y.SCT.FRGHT.CHG = R.SCT.REC<SCT.FREIGHT.CHARGES>
    Y.SCT.FORGN.CHG = R.SCT.REC<SCT.FOREIGN.CHARGES>
    Y.SCT.LAGNT.COMM = R.SCT.REC<SCT.LOC.AGENT.COMM>
    Y.SCT.JOB.EXCHG.RTE = R.SCT.REC<SCT.JOB.EXCHG.RATE>

* calculate proportionate charge Amt and net FOB value against SCT replacement Amt entered in ELC
    Y.SCT.FRGHT.CHG = (Y.SCT.FRGHT.CHG * Y.TF.CONT.RAMT)/Y.SCT.CONT.AMT
    Y.SCT.FORGN.CHG = (Y.SCT.FORGN.CHG * Y.TF.CONT.RAMT)/Y.SCT.CONT.AMT
    Y.SCT.LAGNT.COMM = (Y.SCT.LAGNT.COMM * Y.TF.CONT.RAMT)/Y.SCT.CONT.AMT
    Y.NET.FOB.VAL = Y.TF.CONT.RAMT-(Y.SCT.FRGHT.CHG + Y.SCT.FORGN.CHG + Y.SCT.LAGNT.COMM)
    
* calculate proportionate BTB & PCECC entitlement Amt against SCT replacement Amt entered in ELC
* which is already updated to JOB Register
    Y.SCT.BTB.ENT.AMT = (Y.NET.FOB.VAL * Y.SCT.BTB.ENT.RATE)/100
    Y.SCT.BTB.ENT.AMT = Y.SCT.BTB.ENT.AMT * Y.SCT.JOB.EXCHG.RTE
    Y.SCT.PC.ENT.AMT = (Y.NET.FOB.VAL * Y.SCT.PCECC.ENT.RATE)/100
    Y.SCT.PC.ENT.AMT = Y.SCT.PC.ENT.AMT * Y.SCT.JOB.EXCHG.RTE
    
* calculate total proportionate BTB & PCECC entitlement Amt against SCT replacement Amt entered in ELC
* which is already updated to JOB Register
    Y.TOT.SCT.BTB.ENT.AMT += Y.SCT.BTB.ENT.AMT
    Y.TOT.SCT.PC.ENT.AMT += Y.SCT.PC.ENT.AMT
RETURN

********************
UPDATE.JOB.REGISTER:
********************
    Y.TF.JOB.NUMBER =  Y.LC.LOC.REF<1,Y.TF.JOB.NUMBER.POS>
    EB.DataAccess.FRead(FN.BTB.JR,Y.TF.JOB.NUMBER,R.JOB.REC,F.BTB.JR,JR.ERR)
    Y.TF.EXCHG.RTE = Y.LC.LOC.REF<1,Y.TF.JB.EX.RTE.POS>
    Y.TF.BTB.EAMT = (Y.LC.LOC.REF<1,Y.TF.BTB.EAMT.POS> * Y.TF.EXCHG.RTE)
    Y.TF.PC.EAMT = (Y.LC.LOC.REF<1,Y.TF.PC.EAMT.POS> * Y.TF.EXCHG.RTE)
    Y.TF.EXCHG.RTE.OLD = Y.LC.LOC.REF.ROLD.LST<1,Y.TF.JB.EX.RTE.POS>
    IF (Y.TF.EXCHG.RTE.OLD NE "" AND Y.TF.EXCHG.RTE.OLD NE '0') THEN
        Y.TF.BTB.EAMT.ROLD = (Y.LC.LOC.REF.ROLD.LST<1,Y.TF.BTB.EAMT.POS> * Y.TF.EXCHG.RTE.OLD)
        Y.TF.PC.EAMT.ROLD = (Y.LC.LOC.REF.ROLD.LST<1,Y.TF.PC.EAMT.POS> * Y.TF.EXCHG.RTE.OLD)
    END ELSE
        Y.TF.BTB.EAMT.ROLD = (Y.LC.LOC.REF.ROLD.LST<1,Y.TF.BTB.EAMT.POS> * Y.TF.EXCHG.RTE)
        Y.TF.PC.EAMT.ROLD = (Y.LC.LOC.REF.ROLD.LST<1,Y.TF.PC.EAMT.POS> * Y.TF.EXCHG.RTE)
    END

* update Replacement ELC record and calculated ELC entitlement Total(Excess Amt + Replace Amt)
* amount to respective JOB register field
    Y.ELC.TF.REFNO = EB.SystemTables.getIdNew()
    Y.ELC.TF.REFNO.LST = R.JOB.REC<BTB.JOB.EX.TF.REF>
    FIND Y.ELC.TF.REFNO IN Y.ELC.TF.REFNO.LST SETTING Y.ELC.TF.REFNO.POS1, Y.ELC.TF.REFNO.POS2, Y.ELC.TF.REFNO.POS3   THEN
        R.JOB.REC<BTB.JOB.EX.BTB.ENT.AMT,Y.ELC.TF.REFNO.POS2> = Y.TF.BTB.EAMT
        R.JOB.REC<BTB.JOB.EX.PC.ENT.AMT,Y.ELC.TF.REFNO.POS2> = Y.TF.PC.EAMT
    END ELSE
        Y.ELC.TF.REF.CNT = DCOUNT(R.JOB.REC<BTB.JOB.EX.TF.REF>,@VM) + 1
        R.JOB.REC<BTB.JOB.EX.TF.REF,Y.ELC.TF.REF.CNT> = EB.SystemTables.getIdNew()
        R.JOB.REC<BTB.JOB.EX.BTB.ENT.AMT,Y.ELC.TF.REF.CNT> = Y.TF.BTB.EAMT
        R.JOB.REC<BTB.JOB.EX.PC.ENT.AMT,Y.ELC.TF.REF.CNT> = Y.TF.PC.EAMT
    END

* update Excess Replaced entitlement Amt(ELC.BTB.ENT.AMT, TOT.BTB.ENT.AMT, TOT.BTB.AVL.AMT) to JOB Register
*   Y.ELC.BTB.ENT.AMT = R.JOB.REC<BTB.JOB.EX.BTB.ENT.AMT>
    Y.TOT.BTB.ENT.AMT = R.JOB.REC<BTB.JOB.TOT.BTB.ENT.AMT>
    Y.TOT.BTB.AVL.AMT = R.JOB.REC<BTB.JOB.TOT.BTB.AVL.AMT>
*   R.JOB.REC<BTB.JOB.EX.BTB.ENT.AMT> = Y.ELC.BTB.ENT.AMT + (Y.TF.BTB.EAMT - Y.TF.BTB.EAMT.ROLD)
    R.JOB.REC<BTB.JOB.TOT.BTB.ENT.AMT> = Y.TOT.BTB.ENT.AMT + (Y.TF.BTB.EAMT - Y.TF.BTB.EAMT.ROLD)
    R.JOB.REC<BTB.JOB.TOT.BTB.AVL.AMT> = Y.TOT.BTB.AVL.AMT + (Y.TF.BTB.EAMT - Y.TF.BTB.EAMT.ROLD)
    
* update Excess Replaced entitlement Amt(ELC.PC.ENT.AMT, TOT.PC.ENT.AMT, TOT.PC.AVL.AMT) to JOB Register
*   Y.ELC.PC.ENT.AMT = R.JOB.REC<BTB.JOB.EX.PC.ENT.AMT>
    Y.TOT.PC.ENT.AMT = R.JOB.REC<BTB.JOB.TOT.PC.ENT.AMT>
    Y.TOT.PC.AVL.AMT = R.JOB.REC<BTB.JOB.TOT.PC.AVL.AMT>
*   R.JOB.REC<BTB.JOB.EX.PC.ENT.AMT>  = Y.ELC.PC.ENT.AMT + (Y.TF.PC.EAMT - Y.TF.PC.EAMT.ROLD)
    R.JOB.REC<BTB.JOB.TOT.PC.ENT.AMT>  = Y.TOT.PC.ENT.AMT + (Y.TF.PC.EAMT - Y.TF.PC.EAMT.ROLD)
    R.JOB.REC<BTB.JOB.TOT.PC.AVL.AMT>  = Y.TOT.PC.AVL.AMT + (Y.TF.PC.EAMT - Y.TF.PC.EAMT.ROLD)

* update audit information to JOB Register
    R.JOB.REC<BTB.JOB.INPUTTER> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcInputter)
    R.JOB.REC<BTB.JOB.AUTHORISER> = EB.SystemTables.getOperator()
    R.JOB.REC<BTB.JOB.CO.CODE> = EB.SystemTables.getIdCompany()

*   WRITE R.JOB.REC ON F.BTB.JR,Y.TF.JOB.NUMBER
    EB.DataAccess.FWrite(FN.BTB.JR,Y.TF.JOB.NUMBER,R.JOB.REC)
RETURN

****************
GET.LOC.REF.POS:
****************
    Y.TF.JOB.NUMBER.POS = FLD.POS<1,1>
    Y.TF.SCONT.ID.POS = FLD.POS<1,2>
    Y.TF.CONT.RAMT.POS = FLD.POS<1,3>
    Y.TF.FULL.REP.POS = FLD.POS<1,4>
    Y.TF.JB.EX.RTE.POS = FLD.POS<1,5>
    Y.TF.BTB.EAMT.POS = FLD.POS<1,6>
    Y.TF.PC.EAMT.POS = FLD.POS<1,7>
RETURN

****************
VARIABLE.ASSIGN:
****************
    Y.LC.LOC.REF=''; Y.LC.LOC.REF.POS=''; Y.SCT.ID.LST=''; Y.SCT.ID.CNT=''; Y.TF.SCONT.ID='';
    Y.SCT.CONT.AMT.USE=''; Y.SCT.CONT.AMT.NAU=''; Y.SCT.AVAIL.AMT=''; Y.TF.FULL.REP.YN =''; Y.TF.CONT.RAMT='';
    Y.REP.ELC.REFNO=''; Y.REP.ELC.REFNO.LST=''; Y.REP.ELC.REFNO.CNT=''; Y.INPUTTER=''; Y.AUTHORISER='';
    Y.SCT.CONT.AMT=''; Y.SCT.BTB.ENT.RATE=''; Y.SCT.PCECC.ENT.RATE=''; Y.SCT.FRGHT.CHG=''; Y.SCT.FORGN.CHG='';
    Y.SCT.LAGNT.COMM=''; Y.SCT.JOB.EXCHG.RTE=''; Y.SCT.LAGNT.COMM=''; Y.NET.FOB.VAL=''; Y.SCT.BTB.ENT.AMT='';
    Y.SCT.PCECC.ENT.AMT=''; Y.SCT.PC.ENT.AMT=''; Y.TOT.SCT.BTB.ENT.AMT=''; Y.TOT.SCT.PC.ENT.AMT='';
    Y.TF.JOB.NUMBER=''; Y.TF.EXCHG.RTE=''; Y.TF.BTB.EAMT=''; Y.TF.PC.EAMT='';
    Y.ELC.TF.REFNO=''; Y.ELC.TF.REFNO.LST=''; Y.ELC.TF.REF.CNT=''; Y.TOT.BTB.ENT.AMT=''; Y.TOT.BTB.AVL.AMT='';
    Y.TOT.PC.ENT.AMT=''; Y.TOT.PC.AVL.AMT=''; Y.INPUTTER=''; Y.COM.ID=''; Y.TF.JOB.NUMBER.POS='';
    Y.TF.SCONT.ID.POS=''; Y.TF.CONT.RAMT.POS=''; Y.TF.FULL.REP.POS=''; Y.TF.JB.EX.RTE.POS='';
    Y.TF.BTB.EAMT.POS=''; Y.TF.PC.EAMT.POS=''
RETURN
END
