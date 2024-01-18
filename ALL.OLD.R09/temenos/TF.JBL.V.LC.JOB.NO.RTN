SUBROUTINE TF.JBL.V.LC.JOB.NO.RTN
*-----------------------------------------------------------------------------
*Subroutine Description:This is a Validation Rtn
*                       This rtn will update the job entitlement value from the job register, when the
*                       respective JOB.NO is given
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBUSANCE)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 07/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $INSERT I_F.BD.BTB.JOB.REGISTER
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Display
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LETTER.OF.CREDIT="F.LETTER.OF.CREDIT"
    F.LETTER.OF.CREDIT=""

    FN.BD.BTB.JOB.REGISTER="F.BD.BTB.JOB.REGISTER"
    F.BD.BTB.JOB.REGISTER=""
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.ENCUR",Y.JOB.ENT.CUR.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.ENTAM",Y.JOB.ENT.AMT.POS)
    Y.JOB.NO=EB.SystemTables.getComi()
    Y.LC.CUST = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER,Y.JOB.NO,R.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER,R.JOB.REG.ERR)
    IF R.JOB.REG.ERR THEN
        EB.SystemTables.setEtext('JOB NUMBER DOES NOT EXIST')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    Y.JOB.CUST = R.BD.BTB.JOB.REGISTER<BTB.JOB.CUSTOMER.NO>
    IF Y.LC.CUST NE Y.JOB.CUST THEN
        EB.SystemTables.setEtext('APPLICANT CUSTOMER NOT MATCH WITH JOB CUSTOMER')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
    Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TEMP<1,Y.JOB.ENT.CUR.POS> = R.BD.BTB.JOB.REGISTER<BTB.JOB.JOB.CURRENCY>
    Y.TEMP<1,Y.JOB.ENT.AMT.POS> = R.BD.BTB.JOB.REGISTER<BTB.JOB.TOT.BTB.AVL.AMT>
    
    
    
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)

    EB.Display.RebuildScreen()
RETURN
*** </region>
END
