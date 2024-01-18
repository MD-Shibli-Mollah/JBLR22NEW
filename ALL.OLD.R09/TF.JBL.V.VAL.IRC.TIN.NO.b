SUBROUTINE TF.JBL.V.VAL.IRC.TIN.NO
*-----------------------------------------------------------------------------
*Subroutine Description: Data Update in LC from Customer Record
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.EXPSIGHT)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 16/03/2020 -                            Retrofit   - Md. Ebrahim Khalil Rian
*                                                 FDS Services Ltd
*-----------------------------------------------------------------------------
*-------------------------------------------------------------------------
    $INCLUDE  I_COMMON
    $INCLUDE  I_EQUATE

    $USING ST.Customer
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    
    IF EB.SystemTables.getMessage() NE '' THEN RETURN
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN


*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    
RETURN
*** </region>

 
*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
OPENFILES:
*** <desc>INITIALISATION </desc>
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)
    
*** </region>

*-----------------------------------------------------------------------------
 
    Y.APPL = "CUSTOMER":FM:"LETTER.OF.CREDIT"
    Y.FIELDS = "LT.IRC.NO":VM:"LT.VAT.NO":VM:"LT.IRC.EXP.DAT":FM:"LT.IRC.NO":VM:"LT.TF.TIN.NO":VM:"LT.VAT.NO":VM:"LT.IRC.EXP.DAT"
    Y.POS = ""
    EB.Updates.MultiGetLocRef(Y.APPL, Y.FIELDS, Y.POS)
    Y.IRC.POS = Y.POS<1,1>
    Y.VAT.POS = Y.POS<1,2>
    Y.EXP.DAT.POS = Y.POS<1,3>
    
    Y.LC.IRC.POS = Y.POS<2,1>
    Y.LC.TIN.POS = Y.POS<2,2>
    Y.LC.VAT.POS = Y.POS<2,3>
    Y.LC.EXP.DAT.POS = Y.POS<2,4>
    
RETURN
*** </region>

 
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.CUST.ID = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.CUSTOMER,Y.CUST.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)

    IF R.CUSTOMER THEN
        Y.TIN.NO = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId>
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.LC.IRC.POS> = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.IRC.POS>
        Y.TEMP<1,Y.LC.TIN.POS> = Y.TIN.NO
        Y.TEMP<1,Y.LC.VAT.POS> = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.VAT.POS>
        Y.TEMP<1,Y.LC.EXP.DAT.POS> = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef><1,Y.EXP.DAT.POS>
        
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef,Y.TEMP)
    END
RETURN

END
