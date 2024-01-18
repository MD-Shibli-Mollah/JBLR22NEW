SUBROUTINE TF.JBL.V.ARR.DW.CUS.DIFFER.CK
*-----------------------------------------------------------------------------
*Subroutine Description: This routine is create for FDBP & IDBP ARR customer and DR Customer differ validation.
*Subroutine Type:
*Attached To    : ACTIVITY API - JBL.TF.FDBP.API & JBL.TF.IBD.API
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 31/12/2020 -                            Created by   - MD. Mahmudur Rahman Udoy,
*                                                 FDS Bangladesh Limited
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING AA.Account
    $USING AA.Framework

*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
  
    Y.DR.PR.REF = ''
    Y.LC.NUM = ''
    Y.CUS.ID = ''
    Y.LC.BEN.CUS = ''
    
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LINKED.TFDR.REF",Y.LINKED.TFDR.REF.POS)
    Y.ARR.LOCAL.REF = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    Y.DR.PR.REF = Y.ARR.LOCAL.REF<1,Y.LINKED.TFDR.REF.POS>
    IF Y.DR.PR.REF EQ '' THEN
        RETURN
    END
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>

    EB.DataAccess.Opf(FN.LC,F.LC)

RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>

    Y.LC.NUM = Y.DR.PR.REF[1,12]
    EB.DataAccess.FRead(FN.LC, Y.LC.NUM, LC.REC, F.LC, ERR)
    IF LC.REC THEN
        Y.LC.BEN.CUS = LC.REC<LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno>
        Y.CUS.ID = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActCustomer>
        IF Y.LC.BEN.CUS NE Y.CUS.ID THEN
            EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
            EB.SystemTables.setAv(Y.LINKED.TFDR.REF.POS)
            EB.SystemTables.setEtext("Arrangement Customer and DR Customer Must be same!")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*** </region>

END
