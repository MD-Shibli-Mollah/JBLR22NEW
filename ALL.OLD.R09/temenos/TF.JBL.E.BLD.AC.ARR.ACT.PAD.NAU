SUBROUTINE TF.JBL.E.BLD.AA.ARR.ACT.PAD.NAU(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.AA.ARR.ACT.PAD-NAU
*Attached As    : BUILD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 16/11/2020 -                            Retrofit   - MD. SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_ENQUIRY.COMMON

*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.FIELDS=ENQ.DATA<2>
    Y.POS=DCOUNT(Y.FIELDS,@VM)+1
    ENQ.DATA<2,Y.POS>="PRODUCT"
    ENQ.DATA<3,Y.POS>="EQ"
    ENQ.DATA<4,Y.POS>="JBL.PD.CS.EPZ.COR.LN JBL.PD.CS.EPZ.COTT.LN JBL.PD.CS.EPZ.ME.LN JBL.PD.CS.EPZ.MICR.LN JBL.PD.CS.EPZ.SE.LN JBL.PD.CS.FR.COR.LN JBL.PD.CS.FR.COTT.LN JBL.PD.CS.FR.ME.LN JBL.PD.CS.FR.MICR.LN JBL.PD.CS.FR.SE.LN JBL.PD.CS.IN.COR.LN JBL.PD.CS.IN.COTT.LN JBL.PD.CS.IN.ME.LN JBL.PD.CS.IN.MICR.LN JBL.PD.CS.IN.SE.LN"
RETURN
*** </region>

END