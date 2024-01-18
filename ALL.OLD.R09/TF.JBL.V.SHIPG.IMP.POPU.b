SUBROUTINE TF.JBL.V.SHIPG.IMP.POPU
*-----------------------------------------------------------------------------
* Modification History :
* 10/28/2020 -                            Retrofit   - SHAJJAD HOSSEN ANIK,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING ST.Config
    $USING MD.Contract
    $USING EB.Foundation
    $USING EB.Updates
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
INITIALISE:
    Y.TF.REF = EB.SystemTables.getComi()
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''
    
    FLD.POS = ''
    APPLICATION.NAME ='MD.DEAL':FM:'LETTER.OF.CREDIT'
    LOCAL.FIELD = 'LT.TF.LCAF.NO':FM:'LT.TF.LCAF.NO'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.MD.LCAF.POS = FLD.POS<1,1>
    Y.LC.LCAF.POS = FLD.POS<2,1>
    
    Y.LC.LCAF = ''
    
RETURN
   
OPENFILE:
    EB.DataAccess.Opf(FN.LC, F.LC)
RETURN
   
PROCESS:
    
    EB.DataAccess.FRead(FN.LC, Y.TF.REF, REC.LC, F.LC, ERR.LC)
    IF REC.LC THEN
        Y.BB.LC = REC.LC<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
        Y.CUST=REC.LC<LC.Contract.LetterOfCredit.TfLcApplicantCustno>
        Y.MRGN.CR.ACC = REC.LC<LC.Contract.LetterOfCredit.TfLcCreditProvisAcc>
        Y.CUR = REC.LC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
        Y.LC.LCAF = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LC.LCAF.POS>
    END
    EB.Foundation.MapLocalFields('MD.DEAL', 'LT.AC.BD.EXLCNO', LT.AC.BD.EXLCNO.POS)
    Y.TEMP = EB.SystemTables.getRNew(MD.Contract.Deal.DeaLocalRef)
    Y.TEMP<1,LT.AC.BD.EXLCNO.POS> = Y.BB.LC
    Y.TEMP<1,Y.MD.LCAF.POS> = Y.LC.LCAF
    
    
    EB.SystemTables.setRNew(MD.Contract.Deal.DeaCustomer, Y.CUST)
    EB.SystemTables.setRNew(MD.Contract.Deal.DeaProvDrAccount, Y.MRGN.CR.ACC)
    EB.SystemTables.setRNew(MD.Contract.Deal.DeaLocalRef, Y.TEMP)
    EB.SystemTables.setRNew(MD.Contract.Deal.DeaCurrency, Y.CUR)
    

RETURN
END