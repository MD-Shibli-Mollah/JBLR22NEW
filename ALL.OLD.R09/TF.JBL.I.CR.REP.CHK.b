SUBROUTINE TF.JBL.I.CR.REP.CHK
*-----------------------------------------------------------------------------
*Subroutine Description: Credit Report Checking
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT,JBL.IMPSIGHT Version
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 13/01/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.Foundation
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.OverrideProcessing
    $USING ST.Customer
    $USING EB.API
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
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
    APPLICATION.ID = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)
    
    IF APPLICATION.ID THEN
        EB.DataAccess.FRead(FN.CUSTOMER, APPLICATION.ID, R.CUSTOMER, F.CUSTOMER, CUSTOMER.ERR)
        IF R.CUSTOMER THEN
            EB.Foundation.MapLocalFields("CUSTOMER", "LT.CR.RP.REF":VM:"LT.CR.RP.ISS.DT":VM:"LT.CR.RP.ISS.AU", LT.CR.POS)
            Y.CR.RP.REF.POS = LT.CR.POS<1,1>
            Y.CR.RP.ISS.DT.POS = LT.CR.POS<1,2>
            Y.CR.RP.ISS.AU.POS = LT.CR.POS<1,3>
            Y.CR.REP.REF = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef, Y.CR.RP.REF.POS>
            IF Y.CR.REP.REF THEN
                Y.TODAY = EB.SystemTables.getToday()
                Y.CR.RP.ISS.DT = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef, Y.CR.RP.ISS.DT.POS>
                IF Y.CR.RP.ISS.DT THEN
                    Y.DIFF.DAY = "C"
	                EB.API.Cdd("", Y.CR.RP.ISS.DT, Y.TODAY, Y.DIFF.DAY)
                    
	                IF Y.DIFF.DAY GT 365 THEN
                        EB.SystemTables.setText("Credit Report Issue Date Cross More Than One Year")
                        EB.OverrideProcessing.StoreOverride("")
                    END
                END
            END ELSE
		        EB.SystemTables.setText("Credit Report Not Obtained")
		        EB.OverrideProcessing.StoreOverride("")
		    END
            
        END
    END ELSE
        EB.SystemTables.setText("Credit Report Not Obtained")
        EB.OverrideProcessing.StoreOverride("")
    END
    
RETURN
*** </region>

END
