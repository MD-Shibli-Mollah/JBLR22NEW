SUBROUTINE TF.JBL.I.LD.CUS.CODE
*-----------------------------------------------------------------------------
*Subroutine Description: BB sectore code and SME code mandatory check
*Subroutine Type:
*Attached To    : ACTIVITY API (JBL.TF.AC.FCY.API-19990601 , JBL.TF.AC.LCY.API-19990601 , JBL.TF.AC.FCY.API-19990601 , JBL.TF.FCACTAKA.API-19990601)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING AA.Framework
    $USING EB.LocalReferences
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
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.BB.SECTOR',Y.BB.SECTOR.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER','LT.SME.CODE',Y.SME.CODE.POS)
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
    Y.AA.REC = AA.Framework.Arrangement.Read(Y.ARR.ID, E.AA)
    Y.CUS.ID = Y.AA.REC<AA.Framework.Arrangement.ArrCustomer>
    EB.DataAccess.FRead(FN.CUSTOMER, Y.CUS.ID, R.CUSTOMER, F.CUSTOMER, E.CUSTOMER)
    IF R.CUSTOMER THEN
        Y.BD.BB.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.BB.SECTOR.POS>
        Y.SME.CODE = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.SME.CODE.POS>


        IF Y.BD.BB.SECTOR EQ '' THEN
            IF Y.SME.CODE EQ '' THEN
                EB.SystemTables.setEtext("Please fill the BB Sector Code and SME Code first in Customer file")
                EB.ErrorProcessing.StoreEndError()
            END
        END

        IF Y.BD.BB.SECTOR EQ '' THEN
            EB.SystemTables.setEtext("Please fill the BB Sector Code first in Customer file")
            EB.ErrorProcessing.StoreEndError()
        END

        IF Y.SME.CODE EQ '' THEN
            EB.SystemTables.setEtext("Please fill the SME Code first in Customer file")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*** </region>
          
END