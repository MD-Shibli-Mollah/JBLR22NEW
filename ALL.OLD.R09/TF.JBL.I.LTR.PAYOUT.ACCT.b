SUBROUTINE TF.JBL.I.LTR.PAYOUT.ACCT
*-----------------------------------------------------------------------------
*Subroutine Type: Set Payout Account
*Attached To    : ACTIVITY API - JBL.TF.LTR.API
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 27/04/2020 -                            Retrofit   - Mahmudur Rahman Udoy,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.BD.LC.AD.CODE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING AA.Settlement
    $USING AA.Account
    $USING AA.Framework
    $USING EB.API

    GOSUB INITIALISE
    GOSUB OPENFILE
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN

INITIALISE:
      
    FN.AD.CODE = 'F.BD.LC.AD.CODE'
    F.AD.CODE  = ''
    
    Y.APP="AA.ARR.ACCOUNT"
    Y.FLDS="LT.TF.IMP.PADID"
    Y.POS= ''
     
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLDS,Y.POS)
    Y.LTR.PAD.ID.POS = Y.POS<1,1>
    
RETURN

OPENFILE:
    EB.DataAccess.Opf(FN.AD.CODE,F.AD.CODE)
RETURN

PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    Y.COMPANY = EB.SystemTables.getIdCompany()
    
    EB.DataAccess.FRead(FN.AD.CODE, Y.COMPANY, REC.AD.CODE, F.AD.CODE, ERR.REC)
    Y.AD.CODE.NUM = REC.AD.CODE<AD.CODE.AD.CODE>
    IF Y.AD.CODE.NUM NE '' THEN
        PROP.CLASS = 'ACCOUNT'
        CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
        AC.R.REC = RAISE(RETURN.VALUES)
        Y.AA.LOC.REF = AC.R.REC<AA.Account.Account.AcLocalRef>
        Y.LTR.PAD.ID = Y.AA.LOC.REF<1, Y.LTR.PAD.ID.POS>
        IF Y.LTR.PAD.ID THEN
            EB.SystemTables.setRNew(AA.Settlement.Settlement.SetPayoutAccount, Y.LTR.PAD.ID)
        END
    END
    
*** </region>
RETURN
 
END
