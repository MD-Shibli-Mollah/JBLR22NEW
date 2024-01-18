SUBROUTINE TF.JBL.V.M.LC.LIMIT.VALIDATN
*-----------------------------------------------------------------------------
*Subroutine Description: LC limit Validation
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH | LETTER.OF.CREDIT,JBL.BTBUSANCE)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING ST.Customer
    $USING LI.Config
    $USING LC.Contract
    $USING EB.API
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING EB.Display
    $USING ST.Config
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

*$INSERT I_F.BD.COUNTRY.CODE
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CUS = 'F.CUSTOMER'
    F.CUS=''

    FN.LIM='F.LIMIT'
    F.LIM=''

    FN.LCS='F.LETTER.OF.CREDIT'
    F.LCS=''

    Y.ID=''
    Y.CUS.ID=''
    Y.LIM.EXP.DATE=''

    R.LIM.REC=''
    LIM.ERR=''

    Y.LR.ID=''
    Y.LR.VAL=''
    Y.LIM.ID=''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CUS,F.CUS)
    EB.DataAccess.Opf(FN.LIM,F.LIM)
    EB.DataAccess.Opf(FN.LCS,F.LCS)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    
* To get the Limit ID from the application
    Y.CUS.ID= EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)

*To get the Limit Value inputed in the version
    Y.LR.VAL = EB.SystemTables.getComi()

    Y.LIM.REF = Y.LR.VAL[1,4]
    Y.LI.PARENT = ''

    I = 1
    Y.ZERO = ''
    FOR I = LEN(FIELD(Y.LR.VAL,".",1)) TO 6
        Y.ZERO = Y.ZERO : "0"
    NEXT I
    Y.LR.VAL=Y.ZERO : Y.LR.VAL

    Y.LIM.ID=Y.CUS.ID:".":Y.LR.VAL

    SEL.CMD = "SELECT ":FN.LIM:" WITH @ID LIKE ":Y.LIM.ID:"...  OR @ID LIKE ...":Y.LR.VAL:".":Y.CUS.ID
*    SEL.CMD = "SELECT ":FN.LIM:" WITH ( @ID LIKE ":Y.LIM.ID:"...  OR @ID LIKE ...":Y.LR.VAL:".":Y.CUS.ID:") @ID"
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP

        REMOVE Y.LIMIT FROM SEL.LIST SETTING POS
    WHILE Y.LIMIT:POS
        EB.DataAccess.FRead(FN.LIM,Y.LIMIT,R.LIM.REC,F.LIM,LIM.ERR)
        IF R.LIM.REC NE '' THEN
            Y.LR.ID=Y.LIMIT
        END
    REPEAT


    IF Y.LR.ID EQ '' THEN
        EB.SystemTables.setEtext("LIMIT REFERENCE NOT DEFINED")
        EB.ErrorProcessing.StoreEndError()
    END


* Read information from the Limit details of the customer

    Y.LIM.EXP.DATE = R.LIM.REC<LI.Config.Limit.ExpiryDate>

    IF Y.LIM.EXP.DATE EQ '' THEN
        EB.SystemTables.setEtext("LIMIT EXPIRY NOT DEFINED")
        EB.ErrorProcessing.StoreEndError()
    END

* To check whether the Limit is expired ?
    IF Y.LIM.EXP.DATE LT EB.SystemTables.getToday() THEN
        EB.SystemTables.setEtext("LIMIT DETAILS OF THE CUSTOMER IS EXPIRED")
        EB.ErrorProcessing.StoreEndError()
    END


* To check whether the Limit is expiring in the next 60 days
    IF Y.LIM.EXP.DATE NE '' THEN

        Y.DAYS='C'
        EB.API.Cdd('', EB.SystemTables.getToday(),Y.LIM.EXP.DATE,Y.DAYS)

        IF Y.DAYS GT 0 AND Y.DAYS LE 120 THEN

            CURR.NO = 0
            CURR.NO = DCOUNT(R.LC.REF<LC.Contract.LetterOfCredit.TfLcOverride>,@VM) + 1
            EB.SystemTables.setText("The limit is going to expire within  ":Y.DAYS:" days")
            EB.OverrideProcessing.StoreOverride(CURR.NO)

        END

    END
RETURN
*** </region>

END
