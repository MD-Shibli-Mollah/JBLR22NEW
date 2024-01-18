SUBROUTINE TF.JBL.V.JOB.CUS.DIFFER.CK
*----------------------------------------------
*Subroutine Description: This routine is create for packing cradite ARR customer and Job Customer
*differ validation.
*Subroutine Type:
*Attached To    : ACTIVITY API - JBL.TF.PC.OPEN.API
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* 31/12/2020 -                            Created by   - MD. Mahmudur Rahman Udoy,
*                                                  FDS Bangladesh Limited
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INCLUDE I_F.BD.BTB.JOB.REGISTER
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING AA.Account
    $USING AA.Framework

    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
    F.BD.BTB.JOB.REGISTER = ''
  
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.TF.JOB.NUMBR",Y.LD.JOB.NO.POS)
    Y.ARR.LOCAL.REF = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
    Y.JOB.NUM = Y.ARR.LOCAL.REF<1,Y.LD.JOB.NO.POS>
    Y.CUS.ID = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActCustomer>
    
RETURN
*** </region>
 

*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>

    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)

RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER, Y.JOB.NUM, AA.REC, F.BD.BTB.JOB.REGISTER, ERR)
    IF AA.REC THEN
        Y.JOB.CUS = AA.REC<BTB.JOB.CUSTOMER.NO>
        IF Y.JOB.CUS NE Y.CUS.ID THEN
            EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
            EB.SystemTables.setAv(Y.LD.JOB.NO.POS)
            EB.SystemTables.setEtext("Arrangement Customer and Job Customer Must be same!")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*** </region>

END
