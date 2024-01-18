SUBROUTINE TF.JBL.E.CNV.BNK.CUS.MNE
*-----------------------------------------------------------------------------
*Subroutine Type: Customer Details by Customer Mnemonic
*Attached To    : JBL.ENQ.BNK.CUS.MNE
*Attached As    : CONVERSION ROUTINE
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History :
* 21/06/2021 -                            Retrofit   - Shajjad Hossen,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.Reports
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
    FN.CUS ='F.CUSTOMER'
    F.CUS =''
    
RETURN

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CUS, F.CUS)
RETURN
*** </region>
PROCESS:
    Y.CUS.ID = EB.Reports.getOData()
    EB.DataAccess.FRead(FN.CUS,Y.CUS.ID,REC.CUS,F.CUS,CUS.ERR)
    Y.CUS.NAME = REC.CUS<ST.Customer.Customer.EbCusShortName>
    Y.ACC.OFCR = REC.CUS<ST.Customer.Customer.EbCusAccountOfficer>
    Y.CUS.NAT = REC.CUS<ST.Customer.Customer.EbCusNationality>
    Y.CUS.RES = REC.CUS<ST.Customer.Customer.EbCusResidence>
    Y.CUS.SEC = REC.CUS<ST.Customer.Customer.EbCusSector>
    Y.CUS.INDUS = REC.CUS<ST.Customer.Customer.EbCusIndustry>
    Y.REF = Y.CUS.NAME: "*" :Y.ACC.OFCR: "*" :Y.CUS.NAT: "*" :Y.CUS.RES: "*" :Y.CUS.SEC: "*" :Y.CUS.INDUS
    EB.Reports.setOData(Y.REF)
RETURN

END
