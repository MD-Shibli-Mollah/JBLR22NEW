*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TF.JBL.CO.SWIFT(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)
 
****************************
*
* Modification History
*
* 03/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for Company swift code
*            mapping process of AA
*            Used in DE.FORMAT.PRINT-1798.57.1.GB & 1797.57.1.GB
*
******************************

    $USING EB.Utility
    $USING EB.DataAccess
*    $USING DE.Config
	$USING PY.Config
    
    FN.DE.ADDR='F.DE.ADDRESS'
    F.DE.ADDR=''
    
    Y.SWFT = ''
    
    EB.DataAccess.Opf(FN.DE.ADDR, F.DE.ADDR)
    
    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    Y.ID = RECURRENCE : ".SWIFT.1"
    EB.DataAccess.FRead(FN.DE.ADDR, Y.ID, REC.SFT, F.DE.ADDR, ERR.SFT)
    IF REC.SFT THEN
*        Y.SWFT = REC.SFT<DE.Config.Address.AddDeliveryAddress>
		Y.SWFT = REC.SFT<PY.Config.Address.AddDeliveryAddress>		
    END
    Y.1ST.SFT=Y.SWFT[1,8]
    Y.2ND.SFT=Y.SWFT[10,3]
    OUT.MASK = Y.1ST.SFT : Y.2ND.SFT
    

    OUT.FREQ = OUT.MASK

RETURN

END