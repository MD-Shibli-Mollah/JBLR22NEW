SUBROUTINE TF.JBL.E.BLD.AA.ARR.ACT.FDBP.NAU(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.AA.ARR.ACT.FDBP-NAU
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
    ENQ.DATA<4,Y.POS>="JBL.FR.DC.BL.PR.CR.EXI.LN JBL.FR.DC.BL.PR.CT.EXI.LN JBL.FR.DC.BL.PR.MC.EXI.LN JBL.FR.DC.BL.PR.ME.EXI.LN JBL.FR.DC.BL.PR.SE.EXI.LN JBL.FR.DC.BL.PR.CR.LN JBL.FR.DC.BL.PR.CT.LN JBL.FR.DC.BL.PR.ME.LN JBL.FR.DC.BL.PR.MC.LN JBL.FR.DC.BL.PR.SE.LN"
RETURN
*** </region>

END