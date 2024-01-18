SUBROUTINE TF.JBL.E.BLD.AA.ARR.ACT.LTR.NAU(ENQ.DATA)
*-----------------------------------------------------------------------------
*Subroutine Description: This build routine to alter the selection list of category
*Subroutine Type:
*Attached To    : JBL.ENQ.AA.ARR.ACT.LTR-NAU
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
    ENQ.DATA<4,Y.POS>="JBL.TRST.REC.EXI.COR.LN JBL.TRST.REC.EXI.COT.LN JBL.TRST.REC.EXI.ME.LN JBL.TRST.REC.EXI.MIC.LN JBL.TRST.REC.EXI.SE.LN JBL.TRST.REC.COR.LN JBL.TRST.REC.COT.LN JBL.TRST.REC.ME.LN JBL.TRST.REC.MIC.LN JBL.TRST.REC.SE.LN LTR.NON.REV.COR.LN LTR.NON.REV.COT.LN LTR.NON.REV.ME.LN LTR.NON.REV.MIC.LN LTR.NON.REV.SE.LN"
RETURN
*** </region>

END
