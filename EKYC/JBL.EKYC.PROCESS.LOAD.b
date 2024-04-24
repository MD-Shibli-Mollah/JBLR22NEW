SUBROUTINE JBL.EKYC.PROCESS.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.TP.INFO
    $INSERT I_F.EB.JBL.EKYC.INFO
    $INSERT I_F.JBL.EKYC.PROCESS.COMMON
    
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING EB.Interface
    
    CRT 'LOADING.....................'
    
    FN.CUS      = 'F.CUSTOMER';             F.CUS       = ''
    FN.CUS.NAU  = 'F.CUSTOMER$NAU';         F.CUS.NAU   = ''
    FN.AC       = 'F.ACCOUNT';              F.AC        = ''
    FN.EKYC     = 'F.EB.JBL.EKYC.INFO';     F.EKYC      = ''
    FN.TP       = 'F.EB.JBL.TP.INFO';       F.TP        = ''
        
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    EB.DataAccess.Opf(FN.AC, F.AC)
    EB.DataAccess.Opf(FN.EKYC, F.EKYC)
    EB.DataAccess.Opf(FN.TP, F.TP)
RETURN
