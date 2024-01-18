SUBROUTINE TF.JBL.A.LC.PI.UPDT
*-----------------------------------------------------------------------------
*Subroutine Description: update PI infromation to JBL.PI from LC opening
*Attached To    : LC Version (LC,JBL.IMPSIGHT ; LC,JBL.IMPUSANCE, LETTER.OF.CREDIT,JBL.BTBSIGHT, LETTER.OF.CREDIT,JBL.BTBUSANCE , LETTER.OF.CREDIT,JBL.EDFOPEN)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 19/03/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.PI
*
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.OverrideProcessing
*-----------------------------------------------------------------------------
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    FN.PI = 'F.JBL.PI'
    F.PI = ''
    
    APPLICATION.NAMES = 'LETTER.OF.CREDIT'
    LOCAL.FIELDS = 'LT.TF.INCOTERM':VM:'LT.TF.LC.TENOR'
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.INCOTERM.POS = FLD.POS<1,1>
    Y.TENOR.POS = FLD.POS<1,2>
RETURN
**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.PI,F.PI)
RETURN
********
PROCESS:
********
    Y.LC.ID = EB.SystemTables.getIdNew()
    
    R.PI = ""
    R.PI<PI.APPLICANT.CUSTNO> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)
    Y.COUNT = "1"
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno) THEN
        R.PI<PI.BENEFICIARY, Y.COUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno)
        Y.COUNT++
    END
    
    Y.BENEFICIARY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcBeneficiary)
    Y.COUNT.BEN = DCOUNT(Y.BENEFICIARY,@VM) + 1
    Y.TEMP.C = "1"
    LOOP
        IF Y.TEMP.C EQ Y.COUNT.BEN THEN BREAK
        R.PI<PI.BENEFICIARY, Y.COUNT> = FIELD(Y.BENEFICIARY, @VM, Y.TEMP.C)
        Y.TEMP.C++;Y.COUNT++
    REPEAT
               
    R.PI<PI.INCO.TERMS> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1, Y.INCOTERM.POS>
    R.PI<PI.TENOR> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1, Y.TENOR.POS>
    R.PI<PI.OLD.LC.NUMBER> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOldLcNumber)
    
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOtherDespatchDet) EQ "" THEN
        R.PI<PI.PORT.SHIPMENT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcShipDespatch)
    END ELSE
        R.PI<PI.PORT.SHIPMENT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOtherDespatchDet)
    END
    
    IF EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcTransportation) EQ "" THEN
        R.PI<PI.PORT.DISCHARGE> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcFinalDestination)
    END ELSE
        R.PI<PI.PORT.DISCHARGE> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcTransportation)
    END
          
    EB.DataAccess.FWrite(FN.PI, Y.LC.ID, R.PI)
    EB.SystemTables.setText("Proforma Invoice record created. Please update your Proforma Invoice information.")
    EB.OverrideProcessing.StoreOverride("")
    
RETURN


END
