SUBROUTINE TF.JBL.I.MODE.OF.OPR
*-----------------------------------------------------------------------------
*Subroutine Description:To Display error messages if committed without giving JOINT.HOLDER
*                        POA.HOLDER or MANDATE.HOLDER details
*Subroutine Type:
*Attached To    : AA.ARR.ACCOUNT,AA.AC Version
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 01/03/2020 -                            retrofite   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING AA.Framework
    $USING AA.Account
    $USING AA.Customer
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    
    Y.NULL = ''
    Y.POA = ''
    Y.MANDATE = ''
    
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.MOD.OPRTR',Y.MODE.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.MPA',Y.MPA.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.MPA.HLDRN',Y.MPA.HLDRN.POS)
    
*    CALL GET.LOC.REF('ACCOUNT','MANDATE.HOLDER',Y.MANDATE.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    
    PROP.CLASS = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    AC.R.REC = RAISE(RETURN.VALUES)
    Y.TEMP.DATA = AC.R.REC<AA.Account.Account.AcLocalRef>
    Y.MODE.OPR = Y.TEMP.DATA<1,Y.MODE.POS>
    Y.MPA = Y.TEMP.DATA<1,Y.MPA.POS>
    IF Y.MPA EQ "POA" THEN
        Y.POA = Y.TEMP.DATA<1,Y.MPA.HLDRN.POS>
    END ELSE
        Y.MANDATE = Y.TEMP.DATA<1,Y.MPA.HLDRN.POS>
    END
        
    
    PROP.CLASS = 'CUSTOMER'
    AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    CUS.R.REC = RAISE(RETURN.VALUES)
    Y.JOINT.HOLDER = CUS.R.REC<AA.Customer.Customer.CusCustomer>
    
    IF Y.JOINT.HOLDER<1,2> EQ "" THEN
        Y.JOINT.HOLDER = ""
    END
    
    BEGIN CASE
        CASE Y.MODE.OPR EQ "Joint"
            IF (Y.JOINT.HOLDER EQ Y.NULL) THEN
*                EB.SystemTables.setAf(AA.Customer.Customer.CusCustomer)
                EB.SystemTables.setEtext("Enter Joint Holder Details")
                EB.ErrorProcessing.StoreEndError()
            END

        CASE Y.MODE.OPR EQ "Jointly or Survivor"

            IF (Y.JOINT.HOLDER EQ Y.NULL) THEN
*                EB.SystemTables.setAf(AA.Customer.Customer.CusCustomer)
                EB.SystemTables.setEtext("Enter Joint Holder Details")
                EB.ErrorProcessing.StoreEndError()        ;*JBL001 -e
            END

        CASE Y.MODE.OPR EQ "Power of Attorney Holder"

            IF (Y.POA EQ Y.NULL) THEN
                EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                EB.SystemTables.setAv(Y.MPA.HLDRN.POS)
                EB.SystemTables.setEtext("Enter Power of Attorney Holder Details")
                EB.ErrorProcessing.StoreEndError()        ;*JBL001 -e
            END

        CASE Y.MODE.OPR EQ "Mandate Holder"

            IF (Y.MANDATE EQ Y.NULL) THEN
                EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
                EB.SystemTables.setAv(Y.MPA.HLDRN.POS)
                EB.SystemTables.setEtext("Enter Mandate Holder Details")
                EB.ErrorProcessing.StoreEndError()        ;*JBL001 -e
            END

        CASE Y.MODE.OPR EQ "Either or Survivor"

            IF (Y.JOINT.HOLDER EQ Y.NULL) THEN
*                EB.SystemTables.setAf(AA.Customer.Customer.CusCustomer)
                EB.SystemTables.setEtext("Enter Joint Holder Details")
                EB.ErrorProcessing.StoreEndError()        ;*JBL001 -e
            END

    END CASE
        
RETURN
*** </region>


END
