* @ValidationCode : MjotMTc4Mjc1NDQ5MzpDcDEyNTI6MTYwMzc3NDM2OTE0NjpERUxMOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2020 10:52:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
SUBROUTINE CR.BD.NPA.A.MAN.CLASS.UPDATE
*-----------------------------------------------------------------------------
* Developed By- s.azam@fortress-global.com
* This is an API Routine which is used to Developed to update the
* Classification Status manual
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.BD.NPA.STATUS.DETAILS
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AA.Framework
    $USING AA.Account
    $USING EB.Foundation
    $USING AA.PaymentSchedule
    $USING AA.Interest
    $USING EB.Interface
    $USING EB.TransactionControl
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() EQ 'A' THEN
        GOSUB INIT
        GOSUB OPENFILES
        GOSUB PROCESS
    END
RETURN

*----
INIT:
*----
    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    FN.AAD = 'F.AA.ACCOUNT.DETAILS'
    F.AAD = ''
    FN.BD.NPA.STATUS = 'F.BD.NPA.STATUS.DETAILS'
    F.BD.NPA.STATUS = ''
    
    APPLICATION.NAME = 'AA.ARR.ACCOUNT'
    LOCAL.FIELDS = 'LT.QJ.MARK':VM:'LT.MAIN.MANUAL':VM:'LT.LN.TYPE':VM:'LT.ASSET.CLASS':VM:'LT.SUS.MARK'
    EB.Foundation.MapLocalFields(APPLICATION.NAME, LOCAL.FIELDS, FLD.POS)
    Y.QJ.MARK.POS = FLD.POS<1,1>
    Y.MAIN.MANUAL.POS = FLD.POS<1,2>
    Y.LN.TYPE.POS = FLD.POS<1,3>
    Y.ASSET.CLASS.POS = FLD.POS<1,4>
    Y.SUSP.STATUS.POS = FLD.POS<1,5>
RETURN

*--------
OPENFILES:
*--------
    EB.DataAccess.Opf(FN.AA,F.AA)
    EB.DataAccess.Opf(FN.AAD,F.AAD)
    EB.DataAccess.Opf(FN.BD.NPA.STATUS,F.BD.NPA.STATUS)
RETURN

*-------
PROCESS:
*-------
    Y.ARR.ID = c_aalocArrId
    Y.c_aalocActivityStatus = c_aalocActivityStatus
    EB.DataAccess.FRead(FN.AA, Y.ARR.ID, R.AA, F.AA, ERR.AA)
    Y.COM = R.AA<AA.Framework.Arrangement.ArrCoCode>
    Y.PRODUCT.LINE = R.AA<AA.Framework.Arrangement.ArrProductLine>
    Y.PRODUCT.GROUP = R.AA<AA.Framework.Arrangement.ArrProductGroup>
    
    Y.LOCAL.DATA = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    Y.ASSET.CLASS = Y.LOCAL.DATA<1,Y.ASSET.CLASS.POS>
    Y.QJ.MARK = Y.LOCAL.DATA<1,Y.QJ.MARK.POS>
    Y.MAINTAIN.MANUAL = Y.LOCAL.DATA<1,Y.MAIN.MANUAL.POS>
    Y.SUSP.STATUS = Y.LOCAL.DATA<1,Y.SUSP.STATUS.POS>
      
    IF Y.ASSET.CLASS EQ '50' THEN
        Y.DATE = EB.SystemTables.getToday()
        Y.CCY = 'BDT'
        GOSUB TRIGGER.CHANGE.PRINCIPALINT
    END

    IF Y.SUSP.STATUS EQ 'YES' THEN
        Y.DATE = EB.SystemTables.getToday()
        GOSUB TRIGGER.SUSPEND.ARR
    END

*    IF (Y.ASSET.CLASS EQ '10' OR Y.ASSET.CLASS EQ '20') THEN
    IF Y.SUSP.STATUS NE 'YES' THEN
        Y.DATE = EB.SystemTables.getToday()
        GOSUB TRIGGER.RESUME.ARR
    END
    GOSUB UPDATE.ASSET.CLASS
RETURN
*--------------
GET.CONDITIONS:
*--------------
    AA.Framework.GetArrangementConditions(Y.ARR.ID,Y.PROPERTY.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    R.REC = RAISE(RETURN.VALUES)
RETURN

*---------------------------
TRIGGER.CHANGE.PRINCIPALINT:
*---------------------------
    Y.PROP.CLASS = 'INTEREST'
    GOSUB GET.CONDITIONS
    Y.INT.RATE = R.REC<AA.Interest.Interest.IntFixedRate><1>
    IF Y.INT.RATE NE '0' THEN
        Y.ACTIVITY = 'LENDING-CHANGE-PRINCIPALINT'
        Y.PROPERTY = 'PRINCIPALINT'
        IF Y.PRODUCT.LINE EQ 'ACCOUNTS' THEN
            Y.ACTIVITY = 'ACCOUNTS-CHANGE-DRINTEREST'
            Y.PROPERTY = 'DRINTEREST'
        END
        OFS.STRING = ''
        OFS.STRING = 'AA.ARRANGEMENT.ACTIVITY,BD.NPA/I/PROCESS,//':Y.COM
        OFS.STRING := ',,ARRANGEMENT::=':Y.ARR.ID:',ACTIVITY::=':Y.ACTIVITY
        OFS.STRING := ',EFFECTIVE.DATE::=':Y.DATE:',CURRENCY::=':Y.CCY
        OFS.STRING := ',PROPERTY:1:1=':Y.PROPERTY:',FIELD.NAME:1:1=FIXED.RATE:1:1,FIELD.VALUE:1:1=0'
        OFS.SOURCE = 'JBL.PRE.OFS'
        OFS.MSG.ID = ''
        OPTIONS = ''
        EB.Interface.OfsCallBulkManager(OFS.SOURCE, OFS.STRING,OFS.MSG.ID, OPTIONS)
*EB.Interface.OfsPostMessage(OFS.STRING, OFS.MSG.ID, OFS.SOURCE, OPTIONS)
        EB.TransactionControl.JournalUpdate('')
        SENSITIVITY = ''
    END
RETURN
*------------------
TRIGGER.RESUME.ARR:
*------------------
    Y.ACTIVITY = 'LENDING-RESUME-ARRANGEMENT'
    IF Y.PRODUCT.LINE EQ 'ACCOUNTS' THEN
        Y.ACTIVITY = 'ACCOUNTS-RESUME-ARRANGEMENT'
    END
    OFS.STRING = ''
    OFS.SOURCE = 'JBL.PRE.OFS'
*    OFS.STRING = 'AA.ARRANGEMENT.ACTIVITY,BD.NPA/I/PROCESS,//':Y.COM
*    OFS.STRING := ',,ARRANGEMENT::=':Y.ARR.ID:',ACTIVITY::=':Y.ACTIVITY
*    OFS.STRING := ',EFFECTIVE.DATE::=':Y.DATE
    R.REC<AA.Framework.ArrangementActivity.ArrActArrangement> = Y.ARR.ID
    R.REC<AA.Framework.ArrangementActivity.ArrActActivity> = Y.ACTIVITY
    R.REC<AA.Framework.ArrangementActivity.ArrActEffectiveDate> = Y.DATE
    OFS.ERR = ''
    OFS.MSG.ID = ''
    EB.Foundation.OfsBuildRecord('AA.ARRANGEMENT.ACTIVITY', 'I', 'PROCESS', 'AA.ARRANGEMENT.ACTIVITY,BD.NPA', "" ,"0" ,"", R.REC, OFS.STRING);* building the OFS.RECORD
    EB.Interface.OfsCallBulkManager(OFS.SOURCE, OFS.STRING,OFS.MSG.ID, OPTIONS)
*EB.Interface.OfsPostMessage(OFS.STRING, OFS.MSG.ID, OFS.SOURCE, OPTIONS)
*EB.TransactionControl.JournalUpdate('')
*SENSITIVITY = ''
RETURN
*-------------------
TRIGGER.SUSPEND.ARR:
*-------------------
    Y.ACTIVITY = 'LENDING-SUSPEND-ARRANGEMENT'
    IF Y.PRODUCT.LINE EQ 'ACCOUNTS' THEN
        Y.ACTIVITY = 'ACCOUNTS-SUSPEND-ARRANGEMENT'
    END
    OFS.STRING = ''
    OFS.SOURCE= 'JBL.PRE.OFS'
*    OFS.STRING = 'AA.ARRANGEMENT.ACTIVITY,BD.NPA/I/PROCESS,//':Y.COM
*    OFS.STRING := ',,ARRANGEMENT::=':Y.ARR.ID:',ACTIVITY::=':Y.ACTIVITY
*    OFS.STRING := ',EFFECTIVE.DATE::=':Y.DATE
    R.REC<AA.Framework.ArrangementActivity.ArrActArrangement> = Y.ARR.ID
    R.REC<AA.Framework.ArrangementActivity.ArrActActivity> = Y.ACTIVITY
    R.REC<AA.Framework.ArrangementActivity.ArrActEffectiveDate> = Y.DATE
    OFS.ERR = ''
    OFS.MSG.ID = ''
    EB.Foundation.OfsBuildRecord('AA.ARRANGEMENT.ACTIVITY', 'I', 'PROCESS', 'AA.ARRANGEMENT.ACTIVITY,BD.NPA', "" ,"0" ,"", R.REC, OFS.STRING);* building the OFS.RECORD
    EB.Interface.OfsCallBulkManager(OFS.SOURCE, OFS.STRING,OFS.MSG.ID, OPTIONS)
*EB.Interface.OfsPostMessage(OFS.STRING, OFS.MSG.ID, OFS.SOURCE, OPTIONS)
*EB.TransactionControl.JournalUpdate('')
*SENSITIVITY = ''
    
*    Y.ACTIVITY = 'LENDING-AGE-OVERDUE*STD*INTEREST'
*    IF Y.PRODUCT.LINE EQ 'ACCOUNTS' THEN
*        Y.ACTIVITY = 'ACCOUNTS-AGE.OVERDRAFT-LIMIT*GRC'
*    END
*    OFS.STRING = ''
*    OFS.SOURCE= 'JBL.PRE.OFS'
*    OFS.STRING = 'AA.ARRANGEMENT.ACTIVITY,BD.NPA/I/PROCESS,//':Y.COM
*    OFS.STRING := ',,ARRANGEMENT::=':Y.ARR.ID:',ACTIVITY::=':Y.ACTIVITY
*    OFS.STRING := ',EFFECTIVE.DATE::=':Y.DATE
*    OFS.ERR = ''
*    OFS.MSG.ID = ''
*    EB.Interface.OfsCallBulkManager(OFS.SOURCE, OFS.STRING,OFS.MSG.ID, OPTIONS)
**EB.Interface.OfsPostMessage(OFS.STRING, OFS.MSG.ID, OFS.SOURCE, OPTIONS)
*    EB.TransactionControl.JournalUpdate('')
*    SENSITIVITY = ''
RETURN

*------------------
UPDATE.ASSET.CLASS:
*------------------
    EB.DataAccess.FRead(FN.BD.NPA.STATUS, Y.ARR.ID, R.NPA.DET, F.BD.NPA.STATUS, ERR.NPA.DET)
    Y.NPA.DET.LAST.ASSET.CLASS = R.NPA.DET<BD.NPA.DET.LAST.ASSET.CLASS>
    IF Y.NPA.DET.LAST.ASSET.CLASS NE Y.ASSET.CLASS THEN
        Y.TOT.STATUS.CHNG = DCOUNT(R.NPA.DET<BD.NPA.DET.START.DATE>,VM) + 1
        R.NPA.DET<BD.NPA.DET.ASSET.CLASS,Y.TOT.STATUS.CHNG> = Y.ASSET.CLASS
        R.NPA.DET<BD.NPA.DET.START.DATE,Y.TOT.STATUS.CHNG> = EB.SystemTables.getToday()
        R.NPA.DET<BD.NPA.DET.LAST.ASSET.CLASS> = Y.ASSET.CLASS
        R.NPA.DET<BD.NPA.DET.GEN.TYPE> = 'SYSTEM'
        R.NPA.DET<BD.NPA.DET.PRODUCT.GROUP> = Y.PRODUCT.GROUP
        R.NPA.DET<BD.NPA.DET.MAINTAIN_MANUAL> = Y.MAINTAIN.MANUAL
        R.NPA.DET<BD.NPA.DET.INPUTTER> = EB.SystemTables.getOperator()
        R.NPA.DET<BD.NPA.DET.DATE.TIME> = EB.SystemTables.getTimeStamp()
        R.NPA.DET<BD.NPA.DET.AUTHORISER> = EB.SystemTables.getOperator()
        R.NPA.DET<BD.NPA.DET.CO.CODE> = Y.COM
        EB.DataAccess.FWrite(FN.BD.NPA.STATUS,Y.ARR.ID,R.NPA.DET)
        EB.TransactionControl.JournalUpdate('')
        SENSITIVITY = ''
    END
RETURN
END
