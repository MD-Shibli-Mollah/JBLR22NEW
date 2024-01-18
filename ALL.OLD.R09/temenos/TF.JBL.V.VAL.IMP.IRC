SUBROUTINE TF.JBL.V.VAL.IMP.IRC
*-----------------------------------------------------------------------------
*Subroutine Description: Update IRC Related Data in LC from Customer Record
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH | LETTER.OF.CREDIT,JBL.BTBUSANCE
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.DataAccess

    $USING LC.Contract
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.SystemTables
    $USING LC.Config
*-----------------------------------------------------------------------------
    
*IF EB.SystemTables.getMessage() NE '' THEN RETURN
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    FN.LC = "F.LETTER.OF.CREDIT"
    F.LC = ""
    FN.LC.CUS = "F.LC.APPLICANT"
    F.LC.CUS = ""
    
    RIGHT(EB.SystemTables.getIdCompany(),4)
    !Getting local ref field values
    Y.APPL = "CUSTOMER":FM:"LETTER.OF.CREDIT":FM:"LC.TYPES"
    Y.FIELDS = "LT.IRC.NO":VM:"LT.VAT.NO":VM:"LT.IRC.EXP.DAT":VM:"LT.IRC.LIMIT":VM:"LT.CUS.IRC.ISDT":VM:"LT.TF.AVL.LIMIT":FM:"LT.IRC.NO":VM:"LT.TF.TIN.NO":VM:"LT.VAT.NO":VM:"LT.IRC.EXP.DAT":VM:"LT.TF.IRC.RENDT":VM:"LT.TF.AVL.LIMIT":VM:"LT.IRC.LIMIT"
*   CUSTOMER LRT TIN.NO NOW USE CORE TAX.ID
*   LETTER.OF.CREDIT LRT TIN.NO NOW USE CORE TAX.ID
*   CUSTOMER LRT IRC.RENEW.DATE NOW USE FROM LT.CUS.IRC.ISDT
    Y.POS = ""
    EB.Updates.MultiGetLocRef(Y.APPL, Y.FIELDS, Y.POS)
    Y.IRC.POS = Y.POS<1,1>
    Y.VAT.POS = Y.POS<1,2>
    Y.DATE.POS=Y.POS<1,3>
    Y.IRC.RENEW.POS = Y.POS<1,5>
    Y.IRC.LIMIT.POS = Y.POS<1,4>
    Y.IRC.ISS.POS = Y.POS<1,5>
    Y.IRC.AVL.AMT.POS = Y.POS<1,6>
    Y.LC.IRC.POS = Y.POS<2,1>
    Y.LC.TIN.POS = Y.POS<2,2>
    Y.LC.VAT.POS = Y.POS<2,3>
    Y.LC.DATE.POS = Y.POS<2,4>
    Y.LC.IRC.RENEW.POS = Y.POS<2,5>
    Y.LC.IRC.AVAILED.POS = Y.POS<2,6>
    Y.LC.IRC.LIMIT.POS = Y.POS<2,7>
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.CUS,F.LC.CUS)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.CUST.ID = EB.SystemTables.getComi()

    EB.DataAccess.FRead(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)

    IF R.CUSTOMER THEN
        Y.IRC.NO = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.IRC.POS>
        Y.TIN.NO = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId>
        Y.VAT.NO = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.VAT.POS>
        Y.EXP.DATE = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.DATE.POS>
        Y.IRC.ISS.DATE = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.IRC.ISS.POS>
        Y.IRC.RENEW.DATE = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.IRC.RENEW.POS>
        Y.IRC.LIMIT = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.IRC.LIMIT.POS>
        Y.IRC.AVL.AMT = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.IRC.AVL.AMT.POS>

        Y.LC.IRC.RECORDS = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.LC.IRC.RECORDS<1,Y.LC.IRC.POS> = Y.IRC.NO
        Y.LC.IRC.RECORDS<1,Y.LC.TIN.POS> = Y.TIN.NO
        Y.LC.IRC.RECORDS<1,Y.LC.VAT.POS> = Y.VAT.NO
        Y.LC.IRC.RECORDS<1,Y.LC.DATE.POS> = Y.EXP.DATE
        Y.LC.IRC.RECORDS<1,Y.LC.IRC.RENEW.POS> = Y.IRC.ISS.DATE
        Y.LC.IRC.RECORDS<1,Y.LC.IRC.LIMIT.POS> = DROUND(Y.IRC.LIMIT,2)
        Y.LC.IRC.RECORDS<1,Y.LC.IRC.RENEW.POS>=Y.IRC.RENEW.DATE

        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.LC.IRC.RECORDS)
    END

    IF Y.IRC.LIMIT ELSE RETURN
    
    Y.LC.IRC.AVAILED = DROUND(Y.IRC.AVL.AMT,2)

    Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TEMP<1,Y.LC.IRC.AVAILED.POS> = Y.LC.IRC.AVAILED
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
    
    
*    EB.DataAccess.FRead(FN.LC.CUS,Y.CUST.ID,R.LC.CUS,F.LC.CUS,Y.LC.CUS)
*    IF R.LC.CUS THEN
*        Y.LC.NO = R.LC.CUS
*        LOOP
*            R.LC.REC = ''
*            LC.ID = ''
*            REMOVE LC.ID FROM Y.LC.NO SETTING POS
*        WHILE LC.ID:POS DO
*            EB.DataAccess.FRead(FN.LC,LC.ID,R.LC.REC,F.LC,LC.ERR)
*            Y.LC.AMOUNT += R.LC.REC<LC.Contract.LetterOfCredit.TfLcLcAmount>
*        REPEAT
*        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
*        Y.TEMP<1,Y.LC.IRC.AVAILED.POS> = Y.IRC.LIMIT - Y.LC.AMOUNT
*        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
*    END ELSE
*        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
*        Y.TEMP<1,Y.LC.IRC.AVAILED.POS> = Y.IRC.LIMIT
*        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
*    END
RETURN
*** </region>

END
