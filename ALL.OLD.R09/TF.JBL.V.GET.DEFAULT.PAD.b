SUBROUTINE TF.JBL.V.GET.DEFAULT.PAD

*-----------------------------------------------------------------------------
* Activity.Api : JBL.TF.LTR.API
* 09/07/2020 -                            Retrofit   - MAHMUDUR RAHMAN UDOY,
*                                                 FDS Bangladesh Limited
*
* Description: IT READ THE PAD ACCOUNT FORM LTR ARR OPENING SETTLEMENT PROPERTY THROUGH THIS ACCOUNT IT WILL FIND PAD DETAILS FROM PAD CASH ARR
*              AND ASSIGN THEOSE VALUE TO LTR ARR ACCOUNT PROPERTY LOCAL FIELDS.
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING AC.AccountOpening
    $USING AA.Account
    $USING AA.Framework
    $USING AA.Settlement
    $USING EB.API

*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
INITIALISE:
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''

******SET LTR FILEDS************************************
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.LN.IMP.PADAM',Y.PADAMT.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.TF.IMP.PADID',Y.PADID.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.LINK.TFNO',Y.TFNO.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.TFDR.LC.NO',Y.LCNO.POS)
    
******READ FIELD FORM PAD ARR****************************
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.BD.EXLCNO',Y.PAD.LCNO.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.DR.PUR.RN',Y.PAD.TFNO.POS)
RETURN
   
OPENFILE:
    EB.DataAccess.Opf(FN.ACC, F.ACC)
RETURN
   
PROCESS:
    APP.NAME = 'AA.ARR.ACCOUNT'
    EB.API.GetStandardSelectionDets(APP.NAME, R.SS)
    Y.FIELD.NAME = 'LOCAL.REF'
    LOCATE Y.FIELD.NAME IN R.SS<AA.Account.Account.AcLocalRef> SETTING Y.POS THEN
    END
 
    CALL AA.GET.ACCOUNT.RECORD(R.PROPERTY.RECORD, PROPERTY.ID)
    TMP.DATA = R.PROPERTY.RECORD<1,Y.POS>
    Y.ST.ACCT = FIELD(TMP.DATA,SM, Y.PADID.POS)
        
    EB.DataAccess.FRead(FN.ACC, Y.ST.ACCT, REC.ACC, F.ACC, ERR.ACC)
    IF REC.ACC THEN
*    Y.WORK.BAL = REC.ACC<AC.AccountOpening.Account.WorkingBalance>
        Y.PAD.ARR.ID = REC.ACC<AC.AccountOpening.Account.ArrangementId>
        
        PROP.CLASS = 'ACCOUNT'
        AA.Framework.GetArrangementConditions(Y.PAD.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
        IF RETURN.VALUES THEN
            AC.ARR.REC = RAISE(RETURN.VALUES)
            TMP.DATA = AC.ARR.REC<AA.Account.Account.AcLocalRef>
        
            Y.PAD.LCNO = FIELD(TMP.DATA,VM, Y.PAD.LCNO.POS)
            Y.PAD.TFNO = FIELD(TMP.DATA,VM, Y.PAD.TFNO.POS)
        
            Y.TEMP = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
*   Y.TEMP<1,Y.PADAMT.POS> = Y.WORK.BAL
            Y.PAD.TFNO.EXIST = Y.TEMP<1,Y.TFNO.POS>
            IF Y.PAD.TFNO.EXIST EQ '' THEN
                Y.TEMP<1,Y.TFNO.POS> = Y.PAD.TFNO
            END
            Y.PAD.LCNO.EXIST = Y.TEMP<1,Y.LCNO.POS>
            IF Y.PAD.LCNO.EXIST EQ '' THEN
                Y.TEMP<1,Y.LCNO.POS> = Y.PAD.LCNO
            END
            EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef, Y.TEMP)
        END
    END
RETURN

END
