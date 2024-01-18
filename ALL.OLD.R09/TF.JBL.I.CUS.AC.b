SUBROUTINE TF.JBL.I.CUS.AC
*-----------------------------------------------------------------------------
*Subroutine Description: Customer name title wirte in account property
*Subroutine Type:
*Attached To    : ALL TF activity API
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 09/03/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.APP.COMMON
    $INSERT I_AA.LOCAL.COMMON
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING AA.Framework
    $USING EB.LocalReferences
    $USING LC.Contract
    $USING AA.Account
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
RETURN
*** </region>


*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
**********************************************
    Y.CUS.ID = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActCustomer>
    EB.DataAccess.FRead(FN.CUSTOMER, Y.CUS.ID, R.CUSTOMER, F.CUSTOMER, E.CUSTOMER)
    IF R.CUSTOMER THEN
        Y.CUS.TITLE.1 = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
        Y.CUS.ST.NAME = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
        
        Y.ACCT.TITLE.ONE = EB.SystemTables.getRNew(AA.Account.Account.AcAccountTitleOne)
        Y.ACCT.TITLE = EB.SystemTables.getRNew(AA.Account.Account.AcShortTitle)
        
        IF Y.ACCT.TITLE.ONE EQ "" THEN
            EB.SystemTables.setRNew(AA.Account.Account.AcAccountTitleOne, Y.CUS.TITLE.1)
        END
        IF Y.ACCT.TITLE EQ "" THEN
            EB.SystemTables.setRNew(AA.Account.Account.AcShortTitle, Y.CUS.ST.NAME)
        END
    END
    
RETURN
*** </region>

END