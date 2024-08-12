* @ValidationCode : MjoxNjU4NTA5MjUzOkNwMTI1MjoxNjU0NjcyNDg0MzAzOm5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Jun 2022 13:14:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
PROGRAM Y.BUILD.HM.SAVELIST
*-----------------------------------------------------------------------------
*
*Developer Info:
*    Date         : 07/06/2022
*    Description  : Routine for extracting all helptext.menu's versions, equiries and their routines, also menus within menus, etc and make it into a SAVELIST, LT list and Other list containing routines and LRTs.
*    Developed By : Md. Nazibul Islam
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING ST.CompanyCreation
*
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Versions
    $USING EB.Reports
*-----------------------------------------------------------------------------
    ST.CompanyCreation.LoadCompany("BD0010001")
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
INIT:
    INPUT Y.HM.ID
    FN.HM='F.HELPTEXT.MENU'
    F.HM=''
    FN.VER='F.VERSION'
    F.VER=''
    FN.ENQ='F.ENQUIRY'
    F.ENQ=''
    FN.COS='F.EB.COMPOSITE.SCREEN'
    F.COS=''
    FN.TAB='F.EB.TABBED.SCREEN'
    F.TAB=''
    FN.PF='F.PGM.FILE'
    F.PF=''
    WriteData<-1>=''
    WriteLT<-1>=''
    WriteOther<-1>=''
RETURN
OPENFILES:
    EB.DataAccess.Opf(FN.HM,F.HM)
    EB.DataAccess.Opf(FN.VER,F.VER)
    EB.DataAccess.Opf(FN.ENQ,F.ENQ)
    EB.DataAccess.Opf(FN.TAB,F.TAB)
    EB.DataAccess.Opf(FN.PF,F.PF)
RETURN
PROCESS:
    WriteData<-1>='HELPTEXT.MENU>':Y.HM.ID
    EB.DataAccess.FRead(FN.HM, Y.HM.ID, HM.REC, F.HM, HM.ERR)
    Y.HM.APP= HM.REC<EB.SystemTables.HelptextMenu.MenApplication>
    FOR I=1 TO DCOUNT(Y.HM.APP,VM)
        EB.DataAccess.FRead(FN.VER, FIELD(Y.HM.APP<1,I>,' ',1), VER.REC, F.VER, VER.ERR)
        Y.PART1.1= FIELD(Y.HM.APP<1,I>,' ',1)
        Y.PART1.2= FIELD(Y.HM.APP<1,I>,' ',2)
        EB.DataAccess.FRead(FN.HM, Y.HM.APP<1,I>, HM.REC1.2, F.HM, HM.ERR1.2)
        BEGIN CASE
            CASE Y.PART1.1 EQ 'ENQ' OR Y.PART1.1 EQ 'QUERY'
                WriteData<-1>='ENQUIRY>':Y.PART1.2
                EB.DataAccess.FRead(FN.ENQ, Y.PART1.2, ENQ.REC1, F.ENQ, ENQ.ERR)
                Y.ENQ.FLD.NAME1=ENQ.REC1<EB.Reports.Enquiry.EnqFileName>
                IF FIELD(Y.ENQ.FLD.NAME1,'.',1) EQ 'NOFILE' THEN
                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME1
                END
                Y.ENQ.RTN=ENQ.REC1<EB.Reports.Enquiry.EnqBuildRoutine>
                GOSUB WRITERTN2
                Y.CONV.RTN=ENQ.REC1<EB.Reports.Enquiry.EnqConversion>
                GOSUB WRITERTN3
            CASE Y.PART1.1 EQ 'COS'
                WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.PART1.2
                EB.DataAccess.FRead(FN.COS, Y.PART1.2, COS.REC1, F.COS, COS.ERR)
                Y.COS.CONT.TYPE=COS.REC1<EB.SystemTables.CompositeScreen.CsContentType>
                Y.COS.CONT=COS.REC1<EB.SystemTables.CompositeScreen.CsContent>
                FOR II=1 TO DCOUNT(Y.COS.CONT.TYPE,VM)
                    IF Y.COS.CONT.TYPE<1,II> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT<1,II>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT<1,II>,' ',1), ENQ.REC1.2, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME1.2=ENQ.REC1.2<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME1.2,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME1.2
                        END
                        Y.ENQ.RTN=ENQ.REC1.2<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC1.2<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.COS.CONT.TYPE<1,II> EQ 'TAB' THEN
                        WriteData<-1>='EB.TABBED.SCREEN>':Y.COS.CONT<1,II>
                        EB.DataAccess.FRead(FN.TAB, Y.COS.CONT<1,II>, TAB.REC1, F.TAB, TAB.ERR)
                        Y.TAB.CONT.TYPE=TAB.REC1<EB.SystemTables.TabbedScreen.TsContentType>
                        Y.TAB.SRC=TAB.REC1<EB.SystemTables.TabbedScreen.TsSource>
                        FOR II1.2=1 TO DCOUNT(Y.TAB.CONT.TYPE,VM)
                            IF Y.TAB.CONT.TYPE<1,II1.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC<1,II1.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC<1,II1.2>,' ',1), ENQ.REC1.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME1.3=ENQ.REC1.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME1.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME1.3
                                END
                                Y.ENQ.RTN=ENQ.REC1.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC1.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT II1.2
                    END
                NEXT II
            CASE Y.PART1.1 EQ 'TAB'
                WriteData<-1>='EB.TABBED.SCREEN>':Y.PART1.2
                EB.DataAccess.FRead(FN.TAB, Y.PART1.2, TAB.REC1.2, F.TAB, TAB.ERR)
                Y.TAB.CONT.TYPE=TAB.REC1.2<EB.SystemTables.TabbedScreen.TsContentType>
                Y.TAB.SRC=TAB.REC1.2<EB.SystemTables.TabbedScreen.TsSource>
                FOR II=1 TO DCOUNT(Y.TAB.CONT.TYPE,VM)
                    IF Y.TAB.CONT.TYPE<1,II> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC<1,II>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC<1,II>,' ',1), ENQ.REC1.3, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME1.3=ENQ.REC1.3<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME1.3,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME1.3
                        END
                        Y.ENQ.RTN=ENQ.REC1.3<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC1.3<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.TAB.CONT.TYPE<1,II> EQ 'COS' THEN
                        WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.TAB.SRC<1,II>
                        EB.DataAccess.FRead(FN.COS, Y.TAB.SRC<1,II>, COS.REC1.2, F.COS, COS.ERR)
                        Y.COS.CONT.TYPE1.2=COS.REC1.2<EB.SystemTables.CompositeScreen.CsContentType>
                        Y.COS.CONT1.2=COS.REC1.2<EB.SystemTables.CompositeScreen.CsContent>
                        FOR II1.2=1 TO DCOUNT(Y.COS.CONT.TYPE1.2,VM)
                            IF Y.COS.CONT.TYPE1.2<1,II1.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT1.2<1,II1.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT1.2<1,II1.2>,' ',1), ENQ.REC1.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME1.3=ENQ.REC1.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME1.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME1.3
                                END
                                Y.ENQ.RTN=ENQ.REC1.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC1.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT II1.2
                    END
                NEXT II
            CASE VER.REC NE ''
                WriteData<-1>='VERSION>':FIELD(Y.HM.APP<1,I>,' ',1)
                Y.VER.ENQ=VER.REC<EB.Versions.Version.VerDropDown>
                FOR II=1 TO DCOUNT(Y.VER.ENQ,VM)
                    IF Y.VER.ENQ<1,II> NE '' THEN
                        WriteData<-1>='ENQUIRY>':Y.VER.ENQ<1,II>
                        EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ<1,II>, ENQ.REC1.4, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME1.4=ENQ.REC1.4<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME1.4,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME1.4
                        END
                        Y.ENQ.RTN=ENQ.REC1.4<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC1.4<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                NEXT II
                Y.VER.FLD=VER.REC<EB.Versions.Version.VerFieldNo>
                FOR II=1 TO DCOUNT(Y.VER.FLD,VM)
                    IF Y.VER.FLD<1,II> NE '' AND FIELD(Y.VER.FLD<1,II>,'.',1) EQ 'LT' THEN
                        WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD<1,II>,'-',1)
                        WriteOther<-1>=FIELD(Y.HM.APP<1,I>,',',1):'>>>':FIELD(Y.VER.FLD<1,II>,'-',1)
                    END
                NEXT II
                Y.VER.RTN=VER.REC<EB.Versions.Version.VerValidationRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC<EB.Versions.Version.VerInputRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC<EB.Versions.Version.VerAuthRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC<EB.Versions.Version.VerIdRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC<EB.Versions.Version.VerCheckRecRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC<EB.Versions.Version.VerBeforeAuthRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC<EB.Versions.Version.VerAfterUnauRtn>
                GOSUB WRITERTN
                Y.VER.ASSO.VER=VER.REC<EB.Versions.Version.VerAssocVersion>
                FOR II=1 TO DCOUNT(Y.VER.ASSO.VER,VM)
                    WriteData<-1>='VERSION>':Y.VER.ASSO.VER<1,II>
                    EB.DataAccess.FRead(FN.VER, Y.VER.ASSO.VER<1,II>, ASSO.REC, F.VER, ASSO.ERR)
                    Y.VER.ENQ=ASSO.REC<EB.Versions.Version.VerDropDown>
                    FOR II1.2=1 TO DCOUNT(Y.VER.ENQ,VM)
                        IF Y.VER.ENQ<1,II1.2> NE '' THEN
                            WriteData<-1>='ENQUIRY>':Y.VER.ENQ<1,II1.2>
                            EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ<1,II1.2>, ENQ.REC1.4, F.ENQ, ENQ.ERR)
                            Y.ENQ.FLD.NAME1.4=ENQ.REC1.4<EB.Reports.Enquiry.EnqFileName>
                            IF FIELD(Y.ENQ.FLD.NAME1.4,'.',1) EQ 'NOFILE' THEN
                                WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME1.4
                            END
                            Y.ENQ.RTN=ENQ.REC1.4<EB.Reports.Enquiry.EnqBuildRoutine>
                            GOSUB WRITERTN2
                            Y.CONV.RTN=ENQ.REC1.4<EB.Reports.Enquiry.EnqConversion>
                            GOSUB WRITERTN3
                        END
                    NEXT II1.2
                    Y.VER.FLD=ASSO.REC<EB.Versions.Version.VerFieldNo>
                    FOR II1.2=1 TO DCOUNT(Y.VER.FLD,VM)
                        IF Y.VER.FLD<1,II1.2> NE '' AND FIELD(Y.VER.FLD<1,II1.2>,'.',1) EQ 'LT' THEN
                            WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD<1,II1.2>,'-',1)
                            WriteOther<-1>=FIELD(Y.VER.ASSO.VER<1,II>,',',1):'>>>':FIELD(Y.VER.FLD<1,II1.2>,'-',1)
                        END
                    NEXT II1.2
                    Y.VER.RTN=ASSO.REC<EB.Versions.Version.VerValidationRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC<EB.Versions.Version.VerInputRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC<EB.Versions.Version.VerAuthRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC<EB.Versions.Version.VerIdRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC<EB.Versions.Version.VerCheckRecRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC<EB.Versions.Version.VerBeforeAuthRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC<EB.Versions.Version.VerAfterUnauRtn>
                    GOSUB WRITERTN
                NEXT II
            CASE HM.REC1.2 NE ''
                WriteData<-1>='HELPTEXT.MENU>':Y.HM.APP<1,I>
                Y.HM.2=Y.HM.APP<1,I>
                GOSUB MENU2
        END CASE
    NEXT I
    
    
*----------------Tracer-----------------
    CONVERT FM TO CHAR(10) IN WriteData
    FileName = 'SAVELIST-':Y.HM.ID:'.txt'
    FilePath = 'E:\TRACER'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*--------------------Tracer Close----------------
*----------------Tracer LT-----------------
    CONVERT FM TO CHAR(10) IN WriteLT
    FileName = 'SAVELIST-LT-':Y.HM.ID:'.txt'
    FilePath = 'E:\TRACER'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteLT TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*--------------------Tracer Close----------------
*----------------Tracer LT-----------------
    CONVERT FM TO CHAR(10) IN WriteOther
    FileName = 'OTHERLIST-':Y.HM.ID:'.txt'
    FilePath = 'E:\TRACER'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteOther TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*--------------------Tracer Close----------------
RETURN
*
MENU2:
    EB.DataAccess.FRead(FN.HM, Y.HM.2, HM.REC2, F.HM, HM.ERR2)
    Y.HM.APP2= HM.REC2<EB.SystemTables.HelptextMenu.MenApplication>
    FOR J=1 TO DCOUNT(Y.HM.APP2,VM)
        EB.DataAccess.FRead(FN.VER, FIELD(Y.HM.APP2<1,J>,' ',1), VER.REC2, F.VER, VER.ERR2)
        Y.PART2.1= FIELD(Y.HM.APP2<1,J>,' ',1)
        Y.PART2.2= FIELD(Y.HM.APP2<1,J>,' ',2)
        EB.DataAccess.FRead(FN.HM, Y.HM.APP2<1,J>, HM.REC2.1, F.HM, HM.ERR3)
        BEGIN CASE
            CASE Y.PART2.1 EQ 'ENQ' OR Y.PART2.1 EQ 'QUERY'
                WriteData<-1>='ENQUIRY>':Y.PART2.2
                EB.DataAccess.FRead(FN.ENQ, Y.PART2.2, ENQ.REC2, F.ENQ, ENQ.ERR)
                Y.ENQ.FLD.NAME2=ENQ.REC2<EB.Reports.Enquiry.EnqFileName>
                IF FIELD(Y.ENQ.FLD.NAME2,'.',1) EQ 'NOFILE' THEN
                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME2
                END
                Y.ENQ.RTN=ENQ.REC2<EB.Reports.Enquiry.EnqBuildRoutine>
                GOSUB WRITERTN2
                Y.CONV.RTN=ENQ.REC2<EB.Reports.Enquiry.EnqConversion>
                GOSUB WRITERTN3
            CASE Y.PART2.1 EQ 'COS'
                WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.PART2.2
                EB.DataAccess.FRead(FN.COS, Y.PART2.2, COS.REC2, F.COS, COS.ERR)
                Y.COS.CONT.TYPE2=COS.REC2<EB.SystemTables.CompositeScreen.CsContentType>
                Y.COS.CONT2=COS.REC2<EB.SystemTables.CompositeScreen.CsContent>
                FOR JJ=1 TO DCOUNT(Y.COS.CONT.TYPE2,VM)
                    IF Y.COS.CONT.TYPE2<1,JJ> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT2<1,JJ>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT2<1,JJ>,' ',1), ENQ.REC2.2, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME2.2=ENQ.REC2.2<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME2.2,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME2.2
                        END
                        Y.ENQ.RTN=ENQ.REC2.2<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC2.2<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.COS.CONT.TYPE2<1,JJ> EQ 'TAB' THEN
                        WriteData<-1>='EB.TABBED.SCREEN>':Y.COS.CONT2<1,JJ>
                        EB.DataAccess.FRead(FN.TAB, Y.COS.CONT2<1,JJ>, TAB.REC2, F.TAB, TAB.ERR)
                        Y.TAB.CONT.TYPE2=TAB.REC2<EB.SystemTables.TabbedScreen.TsContentType>
                        Y.TAB.SRC2=TAB.REC2<EB.SystemTables.TabbedScreen.TsSource>
                        FOR JJ2.2=1 TO DCOUNT(Y.TAB.CONT.TYPE2,VM)
                            IF Y.TAB.CONT.TYPE2<1,JJ2.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC2<1,JJ2.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC2<1,JJ2.2>,' ',1), ENQ.REC2.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME2.3=ENQ.REC2.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME2.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME2.3
                                END
                                Y.ENQ.RTN=ENQ.REC2.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC2.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT JJ2.2
                    END
                NEXT JJ
            CASE Y.PART2.1 EQ 'TAB'
                WriteData<-1>='EB.TABBED.SCREEN>':Y.PART2.2
                EB.DataAccess.FRead(FN.TAB, Y.PART2.2, TAB.REC2.2, F.TAB, TAB.ERR)
                Y.TAB.CONT.TYPE2=TAB.REC2.2<EB.SystemTables.TabbedScreen.TsContentType>
                Y.TAB.SRC2=TAB.REC2.2<EB.SystemTables.TabbedScreen.TsSource>
                FOR JJ=1 TO DCOUNT(Y.TAB.CONT.TYPE2,VM)
                    IF Y.TAB.CONT.TYPE2<1,JJ> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC2<1,JJ>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC2<1,JJ>,' ',1), ENQ.REC2.3, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME2.3=ENQ.REC2.3<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME2.3,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME2.3
                        END
                        Y.ENQ.RTN=ENQ.REC2.3<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC2.3<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.TAB.CONT.TYPE2<1,JJ> EQ 'COS' THEN
                        WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.TAB.SRC2<1,JJ>
                        EB.DataAccess.FRead(FN.COS, Y.TAB.SRC2<1,JJ>, COS.REC2.2, F.COS, COS.ERR)
                        Y.COS.CONT.TYPE2.2=COS.REC2.2<EB.SystemTables.CompositeScreen.CsContentType>
                        Y.COS.CONT2.2=COS.REC2.2<EB.SystemTables.CompositeScreen.CsContent>
                        FOR JJ2.2=1 TO DCOUNT(Y.COS.CONT.TYPE2.2,VM)
                            IF Y.COS.CONT.TYPE2.2<1,JJ2.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT2.2<1,JJ2.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT2.2<1,JJ2.2>,' ',1), ENQ.REC2.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME2.3=ENQ.REC2.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME2.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME2.3
                                END
                                Y.ENQ.RTN=ENQ.REC2.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC2.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT JJ2.2
                    END
                NEXT JJ
            CASE VER.REC2 NE ''
                WriteData<-1>='VERSION>':FIELD(Y.HM.APP2<1,J>,' ',1)
                Y.VER.ENQ2=VER.REC2<EB.Versions.Version.VerDropDown>
                FOR JJ=1 TO DCOUNT(Y.VER.ENQ2,VM)
                    IF Y.VER.ENQ2<1,JJ> NE '' THEN
                        WriteData<-1>='ENQUIRY>':Y.VER.ENQ2<1,JJ>
                        EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ2<1,JJ>, ENQ.REC2.4, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME2.4=ENQ.REC2.4<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME2.4,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME2.4
                        END
                        Y.ENQ.RTN=ENQ.REC2.4<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC2.4<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                NEXT JJ
                Y.VER.FLD2=VER.REC2<EB.Versions.Version.VerFieldNo>
                FOR JJ=1 TO DCOUNT(Y.VER.FLD2,VM)
                    IF Y.VER.FLD2<1,JJ> NE '' AND FIELD(Y.VER.FLD2<1,JJ>,'.',1) EQ 'LT' THEN
                        WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD2<1,JJ>,'-',1)
                        WriteOther<-1>=FIELD(Y.HM.APP2<1,J>,',',1):'>>>':FIELD(Y.VER.FLD2<1,JJ>,'-',1)
                    END
                NEXT JJ
                Y.VER.RTN=VER.REC2<EB.Versions.Version.VerValidationRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC2<EB.Versions.Version.VerInputRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC2<EB.Versions.Version.VerAuthRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC2<EB.Versions.Version.VerIdRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC2<EB.Versions.Version.VerCheckRecRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC2<EB.Versions.Version.VerBeforeAuthRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC2<EB.Versions.Version.VerAfterUnauRtn>
                GOSUB WRITERTN
                Y.VER.ASSO.VER2=VER.REC2<EB.Versions.Version.VerAssocVersion>
                FOR JJ=1 TO DCOUNT(Y.VER.ASSO.VER2,VM)
                    WriteData<-1>='VERSION>':Y.VER.ASSO.VER2<1,JJ>
                    EB.DataAccess.FRead(FN.VER, Y.VER.ASSO.VER2<1,JJ>, ASSO.REC2, F.VER, ASSO.ERR)
                    Y.VER.ENQ2=ASSO.REC2<EB.Versions.Version.VerDropDown>
                    FOR JJ2.2=1 TO DCOUNT(Y.VER.ENQ2,VM)
                        IF Y.VER.ENQ2<1,JJ2.2> NE '' THEN
                            WriteData<-1>='ENQUIRY>':Y.VER.ENQ2<1,JJ2.2>
                            EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ2<1,JJ2.2>, ENQ.REC2.4, F.ENQ, ENQ.ERR)
                            Y.ENQ.FLD.NAME2.4=ENQ.REC2.4<EB.Reports.Enquiry.EnqFileName>
                            IF FIELD(Y.ENQ.FLD.NAME2.4,'.',1) EQ 'NOFILE' THEN
                                WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME2.4
                            END
                            Y.ENQ.RTN=ENQ.REC2.4<EB.Reports.Enquiry.EnqBuildRoutine>
                            GOSUB WRITERTN2
                            Y.CONV.RTN=ENQ.REC2.4<EB.Reports.Enquiry.EnqConversion>
                            GOSUB WRITERTN3
                        END
                    NEXT JJ2.2
                    Y.VER.FLD2=ASSO.REC2<EB.Versions.Version.VerFieldNo>
                    FOR JJ2.2=1 TO DCOUNT(Y.VER.FLD2,VM)
                        IF Y.VER.FLD2<1,JJ2.2> NE '' AND FIELD(Y.VER.FLD2<1,JJ2.2>,'.',1) EQ 'LT' THEN
                            WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD2<1,JJ2.2>,'-',1)
                            WriteOther<-1>=FIELD(Y.VER.ASSO.VER2<1,JJ>,',',1):'>>>':FIELD(Y.VER.FLD2<1,JJ2.2>,'-',1)
                        END
                    NEXT JJ2.2
                    Y.VER.RTN=ASSO.REC2<EB.Versions.Version.VerValidationRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC2<EB.Versions.Version.VerInputRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC2<EB.Versions.Version.VerAuthRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC2<EB.Versions.Version.VerIdRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC2<EB.Versions.Version.VerCheckRecRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC2<EB.Versions.Version.VerBeforeAuthRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC2<EB.Versions.Version.VerAfterUnauRtn>
                    GOSUB WRITERTN
                NEXT JJ
            CASE HM.REC2.1 NE ''
                WriteData<-1>='HELPTEXT.MENU>':Y.HM.APP2<1,J>
                Y.HM.3=Y.HM.APP2<1,J>
                GOSUB MENU3
        END CASE
    NEXT J
RETURN
MENU3:
    EB.DataAccess.FRead(FN.HM, Y.HM.3, HM.REC3, F.HM, HM.ERR3)
    Y.HM.APP3= HM.REC3<EB.SystemTables.HelptextMenu.MenApplication>
    FOR K=1 TO DCOUNT(Y.HM.APP3,VM)
        EB.DataAccess.FRead(FN.VER, FIELD(Y.HM.APP3<1,K>,' ',1), VER.REC3, F.VER, VER.ERR3)
        Y.PART3.1= FIELD(Y.HM.APP3<1,K>,' ',1)
        Y.PART3.2= FIELD(Y.HM.APP3<1,K>,' ',2)
        EB.DataAccess.FRead(FN.HM, Y.HM.APP3<1,K>, HM.REC3.1, F.HM, HM.ERR3.1)
        BEGIN CASE
            CASE Y.PART3.1 EQ 'ENQ' OR Y.PART3.1 EQ 'QUERY'
                WriteData<-1>='ENQUIRY>':Y.PART3.2
                EB.DataAccess.FRead(FN.ENQ, Y.PART3.2, ENQ.REC3, F.ENQ, ENQ.ERR)
                Y.ENQ.FLD.NAME3=ENQ.REC3<EB.Reports.Enquiry.EnqFileName>
                IF FIELD(Y.ENQ.FLD.NAME3,'.',1) EQ 'NOFILE' THEN
                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME3
                END
                Y.ENQ.RTN=ENQ.REC3<EB.Reports.Enquiry.EnqBuildRoutine>
                GOSUB WRITERTN2
                Y.CONV.RTN=ENQ.REC3<EB.Reports.Enquiry.EnqConversion>
                GOSUB WRITERTN3
            CASE Y.PART3.1 EQ 'COS'
                WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.PART3.2
                EB.DataAccess.FRead(FN.COS, Y.PART3.2, COS.REC3, F.COS, COS.ERR)
                Y.COS.CONT.TYPE3=COS.REC3<EB.SystemTables.CompositeScreen.CsContentType>
                Y.COS.CONT3=COS.REC3<EB.SystemTables.CompositeScreen.CsContent>
                FOR KK=1 TO DCOUNT(Y.COS.CONT.TYPE3,VM)
                    IF Y.COS.CONT.TYPE3<1,KK> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT3<1,KK>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT3<1,KK>,' ',1), ENQ.REC3.2, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME3.2=ENQ.REC3.2<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME3.2,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME3.2
                        END
                        Y.ENQ.RTN=ENQ.REC3.2<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC3.2<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.COS.CONT.TYPE3<1,KK> EQ 'TAB' THEN
                        WriteData<-1>='EB.TABBED.SCREEN>':Y.COS.CONT3<1,KK>
                        EB.DataAccess.FRead(FN.TAB, Y.COS.CONT3<1,KK>, TAB.REC3, F.TAB, TAB.ERR)
                        Y.TAB.CONT.TYPE3=TAB.REC3<EB.SystemTables.TabbedScreen.TsContentType>
                        Y.TAB.SRC3=TAB.REC3<EB.SystemTables.TabbedScreen.TsSource>
                        FOR KK3.2=1 TO DCOUNT(Y.TAB.CONT.TYPE3,VM)
                            IF Y.TAB.CONT.TYPE3<1,KK3.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC3<1,KK3.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC3<1,KK3.2>,' ',1), ENQ.REC3.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME3.3=ENQ.REC3.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME3.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME3.3
                                END
                                Y.ENQ.RTN=ENQ.REC3.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC3.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT KK3.2
                    END
                NEXT KK
            CASE Y.PART3.1 EQ 'TAB'
                WriteData<-1>='EB.TABBED.SCREEN>':Y.PART3.2
                EB.DataAccess.FRead(FN.TAB, Y.PART3.2, TAB.REC3.2, F.TAB, TAB.ERR)
                Y.TAB.CONT.TYPE3=TAB.REC3.2<EB.SystemTables.TabbedScreen.TsContentType>
                Y.TAB.SRC3=TAB.REC3.2<EB.SystemTables.TabbedScreen.TsSource>
                FOR KK=1 TO DCOUNT(Y.TAB.CONT.TYPE3,VM)
                    IF Y.TAB.CONT.TYPE3<1,KK> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC3<1,KK>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC3<1,KK>,' ',1), ENQ.REC3.3, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME3.3=ENQ.REC3.3<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME3.3,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME3.3
                        END
                        Y.ENQ.RTN=ENQ.REC3.3<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC3.3<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.TAB.CONT.TYPE3<1,KK> EQ 'COS' THEN
                        WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.TAB.SRC3<1,KK>
                        EB.DataAccess.FRead(FN.COS, Y.TAB.SRC3<1,KK>, COS.REC3.2, F.COS, COS.ERR)
                        Y.COS.CONT.TYPE3.2=COS.REC3.2<EB.SystemTables.CompositeScreen.CsContentType>
                        Y.COS.CONT3.2=COS.REC3.2<EB.SystemTables.CompositeScreen.CsContent>
                        FOR KK3.2=1 TO DCOUNT(Y.COS.CONT.TYPE3.2,VM)
                            IF Y.COS.CONT.TYPE3.2<1,KK3.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT3.2<1,KK3.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT3.2<1,KK3.2>,' ',1), ENQ.REC3.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME3.3=ENQ.REC3.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME3.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME3.3
                                END
                                Y.ENQ.RTN=ENQ.REC3.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC3.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT KK3.2
                    END
                NEXT KK
            CASE VER.REC3 NE ''
                WriteData<-1>='VERSION>':FIELD(Y.HM.APP3<1,K>,' ',1)
                Y.VER.ENQ3=VER.REC3<EB.Versions.Version.VerDropDown>
                FOR KK=1 TO DCOUNT(Y.VER.ENQ3,VM)
                    IF Y.VER.ENQ3<1,KK> NE '' THEN
                        WriteData<-1>='ENQUIRY>':Y.VER.ENQ3<1,KK>
                        EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ3<1,KK>, ENQ.REC3.4, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME3.4=ENQ.REC3.4<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME3.4,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME3.4
                        END
                        Y.ENQ.RTN=ENQ.REC3.4<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC3.4<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                NEXT KK
                Y.VER.FLD3=VER.REC3<EB.Versions.Version.VerFieldNo>
                FOR KK=1 TO DCOUNT(Y.VER.FLD3,VM)
                    IF Y.VER.FLD3<1,KK> NE '' AND FIELD(Y.VER.FLD3<1,KK>,'.',1) EQ 'LT' THEN
                        WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD3<1,KK>,'-',1)
                        WriteOther<-1>=FIELD(Y.HM.APP3<1,K>,',',1):'>>>':FIELD(Y.VER.FLD3<1,KK>,'-',1)
                    END
                NEXT KK
                Y.VER.RTN=VER.REC3<EB.Versions.Version.VerValidationRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC3<EB.Versions.Version.VerInputRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC3<EB.Versions.Version.VerAuthRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC3<EB.Versions.Version.VerIdRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC3<EB.Versions.Version.VerCheckRecRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC3<EB.Versions.Version.VerBeforeAuthRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC3<EB.Versions.Version.VerAfterUnauRtn>
                GOSUB WRITERTN
                Y.VER.ASSO.VER3=VER.REC3<EB.Versions.Version.VerAssocVersion>
                FOR KK=1 TO DCOUNT(Y.VER.ASSO.VER3,VM)
                    WriteData<-1>='VERSION>':Y.VER.ASSO.VER3<1,KK>
                    EB.DataAccess.FRead(FN.VER, Y.VER.ASSO.VER3<1,KK>, ASSO.REC3, F.VER, ASSO.ERR)
                    Y.VER.ENQ3=ASSO.REC3<EB.Versions.Version.VerDropDown>
                    FOR KK3.2=1 TO DCOUNT(Y.VER.ENQ3,VM)
                        IF Y.VER.ENQ3<1,KK3.2> NE '' THEN
                            WriteData<-1>='ENQUIRY>':Y.VER.ENQ3<1,KK3.2>
                            EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ3<1,KK3.2>, ENQ.REC3.4, F.ENQ, ENQ.ERR)
                            Y.ENQ.FLD.NAME3.4=ENQ.REC3.4<EB.Reports.Enquiry.EnqFileName>
                            IF FIELD(Y.ENQ.FLD.NAME3.4,'.',1) EQ 'NOFILE' THEN
                                WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME3.4
                            END
                            Y.ENQ.RTN=ENQ.REC3.4<EB.Reports.Enquiry.EnqBuildRoutine>
                            GOSUB WRITERTN2
                            Y.CONV.RTN=ENQ.REC3.4<EB.Reports.Enquiry.EnqConversion>
                            GOSUB WRITERTN3
                        END
                    NEXT KK3.2
                    Y.VER.FLD3=ASSO.REC3<EB.Versions.Version.VerFieldNo>
                    FOR KK3.2=1 TO DCOUNT(Y.VER.FLD3,VM)
                        IF Y.VER.FLD3<1,KK3.2> NE '' AND FIELD(Y.VER.FLD3<1,KK3.2>,'.',1) EQ 'LT' THEN
                            WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD3<1,KK3.2>,'-',1)
                            WriteOther<-1>=FIELD(Y.VER.ASSO.VER3<1,KK>,',',1):'>>>':FIELD(Y.VER.FLD3<1,KK3.2>,'-',1)
                        END
                    NEXT KK3.2
                    Y.VER.RTN=ASSO.REC3<EB.Versions.Version.VerValidationRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC3<EB.Versions.Version.VerInputRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC3<EB.Versions.Version.VerAuthRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC3<EB.Versions.Version.VerIdRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC3<EB.Versions.Version.VerCheckRecRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC3<EB.Versions.Version.VerBeforeAuthRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC3<EB.Versions.Version.VerAfterUnauRtn>
                    GOSUB WRITERTN
                NEXT KK
            CASE HM.REC3.1 NE ''
                WriteData<-1>='HELPTEXT.MENU>':Y.HM.APP3<1,K>
                Y.HM.4=Y.HM.APP3<1,K>
                GOSUB MENU4
        END CASE
    NEXT K
RETURN
MENU4:
    EB.DataAccess.FRead(FN.HM, Y.HM.4, HM.REC4, F.HM, HM.ERR4)
    Y.HM.APP4= HM.REC4<EB.SystemTables.HelptextMenu.MenApplication>
    FOR L=1 TO DCOUNT(Y.HM.APP4,VM)
        EB.DataAccess.FRead(FN.VER, FIELD(Y.HM.APP4<1,L>,' ',1), VER.REC4, F.VER, VER.ERR4)
        Y.PART4.1= FIELD(Y.HM.APP4<1,L>,' ',1)
        Y.PART4.2= FIELD(Y.HM.APP4<1,L>,' ',2)
        EB.DataAccess.FRead(FN.HM, Y.HM.APP4<1,L>, HM.REC4.1, F.HM, HM.ERR4.1)
        BEGIN CASE
            CASE Y.PART4.1 EQ 'ENQ' OR Y.PART4.1 EQ 'QUERY'
                WriteData<-1>='ENQUIRY>':Y.PART4.2
                EB.DataAccess.FRead(FN.ENQ, Y.PART4.2, ENQ.REC4, F.ENQ, ENQ.ERR)
                Y.ENQ.FLD.NAME4=ENQ.REC4<EB.Reports.Enquiry.EnqFileName>
                IF FIELD(Y.ENQ.FLD.NAME4,'.',1) EQ 'NOFILE' THEN
                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME4
                END
                Y.ENQ.RTN=ENQ.REC4<EB.Reports.Enquiry.EnqBuildRoutine>
                GOSUB WRITERTN2
                Y.CONV.RTN=ENQ.REC4<EB.Reports.Enquiry.EnqConversion>
                GOSUB WRITERTN3
            CASE Y.PART4.1 EQ 'COS'
                WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.PART4.2
                EB.DataAccess.FRead(FN.COS, Y.PART4.2, COS.REC4, F.COS, COS.ERR)
                Y.COS.CONT.TYPE4=COS.REC4<EB.SystemTables.CompositeScreen.CsContentType>
                Y.COS.CONT4=COS.REC4<EB.SystemTables.CompositeScreen.CsContent>
                FOR LL=1 TO DCOUNT(Y.COS.CONT.TYPE4,VM)
                    IF Y.COS.CONT.TYPE4<1,LL> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT4<1,LL>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT4<1,LL>,' ',1), ENQ.REC4.2, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME4.2=ENQ.REC4.2<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME4.2,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME4.2
                        END
                        Y.ENQ.RTN=ENQ.REC4.2<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC4.2<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.COS.CONT.TYPE4<1,LL> EQ 'TAB' THEN
                        WriteData<-1>='EB.TABBED.SCREEN>':Y.COS.CONT4<1,LL>
                        EB.DataAccess.FRead(FN.TAB, Y.COS.CONT4<1,LL>, TAB.REC4.2, F.TAB, TAB.ERR)
                        Y.TAB.CONT.TYPE4=TAB.REC4.2<EB.SystemTables.TabbedScreen.TsContentType>
                        Y.TAB.SRC4=TAB.REC4.2<EB.SystemTables.TabbedScreen.TsSource>
                        FOR LL4.2=1 TO DCOUNT(Y.TAB.CONT.TYPE4,VM)
                            IF Y.TAB.CONT.TYPE4<1,LL4.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC4<1,LL4.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC4<1,LL4.2>,' ',1), ENQ.REC4.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME4.3=ENQ.REC4.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME4.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME4.3
                                END
                                Y.ENQ.RTN=ENQ.REC4.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC4.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT LL4.2
                    END
                NEXT LL
            CASE Y.PART4.1 EQ 'TAB'
                WriteData<-1>='EB.TABBED.SCREEN>':Y.PART4.2
                EB.DataAccess.FRead(FN.TAB, Y.PART4.2, TAB.REC4, F.TAB, TAB.ERR)
                Y.TAB.CONT.TYPE4=TAB.REC4<EB.SystemTables.TabbedScreen.TsContentType>
                Y.TAB.SRC4=TAB.REC4<EB.SystemTables.TabbedScreen.TsSource>
                FOR LL=1 TO DCOUNT(Y.TAB.CONT.TYPE4,VM)
                    IF Y.TAB.CONT.TYPE4<1,LL> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC4<1,LL>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC4<1,LL>,' ',1), ENQ.REC4.3, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME4.3=ENQ.REC4.3<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME4.3,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME4.3
                        END
                        Y.ENQ.RTN=ENQ.REC4.3<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC4.3<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.TAB.CONT.TYPE4<1,LL> EQ 'COS' THEN
                        WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.TAB.SRC4<1,LL>
                        EB.DataAccess.FRead(FN.COS, Y.TAB.SRC4<1,LL>, COS.REC4.2, F.COS, COS.ERR)
                        Y.COS.CONT.TYPE4.2=COS.REC4.2<EB.SystemTables.CompositeScreen.CsContentType>
                        Y.COS.CONT4.2=COS.REC4.2<EB.SystemTables.CompositeScreen.CsContent>
                        FOR LL4.2=1 TO DCOUNT(Y.COS.CONT.TYPE4.2,VM)
                            IF Y.COS.CONT.TYPE4.2<1,LL4.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT4.2<1,LL4.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT4.2<1,LL4.2>,' ',1), ENQ.REC4.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME4.3=ENQ.REC4.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME4.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME4.3
                                END
                                Y.ENQ.RTN=ENQ.REC4.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC4.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT LL4.2
                    END
                NEXT LL
            CASE VER.REC4 NE ''
                WriteData<-1>='VERSION>':FIELD(Y.HM.APP4<1,L>,' ',1)
                Y.VER.ENQ4=VER.REC4<EB.Versions.Version.VerDropDown>
                FOR LL=1 TO DCOUNT(Y.VER.ENQ4,VM)
                    IF Y.VER.ENQ4<1,LL> NE '' THEN
                        WriteData<-1>='ENQUIRY>':Y.VER.ENQ4<1,LL>
                        EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ4<1,LL>, ENQ.REC4.4, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME4.4=ENQ.REC4.4<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME4.4,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME4.4
                        END
                        Y.ENQ.RTN=ENQ.REC4.4<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC4.4<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                NEXT LL
                Y.VER.FLD4=VER.REC4<EB.Versions.Version.VerFieldNo>
                FOR LL=1 TO DCOUNT(Y.VER.FLD4,VM)
                    IF Y.VER.FLD4<1,LL> NE '' AND FIELD(Y.VER.FLD4<1,LL>,'.',1) EQ 'LT' THEN
                        WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD4<1,LL>,'-',1)
                        WriteOther<-1>=FIELD(Y.HM.APP4<1,L>,',',1):'>>>':FIELD(Y.VER.FLD4<1,LL>,'-',1)
                    END
                NEXT LL
                Y.VER.RTN=VER.REC4<EB.Versions.Version.VerValidationRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC4<EB.Versions.Version.VerInputRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC4<EB.Versions.Version.VerAuthRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC4<EB.Versions.Version.VerIdRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC4<EB.Versions.Version.VerCheckRecRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC4<EB.Versions.Version.VerBeforeAuthRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC4<EB.Versions.Version.VerAfterUnauRtn>
                GOSUB WRITERTN
                Y.VER.ASSO.VER4=VER.REC4<EB.Versions.Version.VerAssocVersion>
                FOR LL=1 TO DCOUNT(Y.VER.ASSO.VER4,VM)
                    WriteData<-1>='VERSION>':Y.VER.ASSO.VER4<1,LL>
                    EB.DataAccess.FRead(FN.VER, Y.VER.ASSO.VER4<1,LL>, ASSO.REC4, F.VER, ASSO.ERR)
                    Y.VER.ENQ4=ASSO.REC4<EB.Versions.Version.VerDropDown>
                    FOR LL4.2=1 TO DCOUNT(Y.VER.ENQ4,VM)
                        IF Y.VER.ENQ4<1,LL4.2> NE '' THEN
                            WriteData<-1>='ENQUIRY>':Y.VER.ENQ4<1,LL4.2>
                            EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ4<1,LL4.2>, ENQ.REC4.4, F.ENQ, ENQ.ERR)
                            Y.ENQ.FLD.NAME4.4=ENQ.REC4.4<EB.Reports.Enquiry.EnqFileName>
                            IF FIELD(Y.ENQ.FLD.NAME4.4,'.',1) EQ 'NOFILE' THEN
                                WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME4.4
                            END
                            Y.ENQ.RTN=ENQ.REC4.4<EB.Reports.Enquiry.EnqBuildRoutine>
                            GOSUB WRITERTN2
                            Y.CONV.RTN=ENQ.REC4.4<EB.Reports.Enquiry.EnqConversion>
                            GOSUB WRITERTN3
                        END
                    NEXT LL4.2
                    Y.VER.FLD4=ASSO.REC4<EB.Versions.Version.VerFieldNo>
                    FOR LL4.2=1 TO DCOUNT(Y.VER.FLD4,VM)
                        IF Y.VER.FLD4<1,LL4.2> NE '' AND FIELD(Y.VER.FLD4<1,LL4.2>,'.',1) EQ 'LT' THEN
                            WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD4<1,LL4.2>,'-',1)
                            WriteOther<-1>=FIELD(Y.VER.ASSO.VER4<1,LL>,',',1):'>>>':FIELD(Y.VER.FLD4<1,LL4.2>,'-',1)
                        END
                    NEXT LL4.2
                    Y.VER.RTN=ASSO.REC4<EB.Versions.Version.VerValidationRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC4<EB.Versions.Version.VerInputRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC4<EB.Versions.Version.VerAuthRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC4<EB.Versions.Version.VerIdRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC4<EB.Versions.Version.VerCheckRecRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC4<EB.Versions.Version.VerBeforeAuthRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC4<EB.Versions.Version.VerAfterUnauRtn>
                    GOSUB WRITERTN
                NEXT LL
            CASE HM.REC4.1 NE ''
                WriteData<-1>='HELPTEXT.MENU>':Y.HM.APP4<1,L>
                Y.HM.5=Y.HM.APP4<1,L>
                GOSUB MENU5
        END CASE
    NEXT L
RETURN
MENU5:
    EB.DataAccess.FRead(FN.HM, Y.HM.5, HM.REC5, F.HM, HM.ERR5)
    Y.HM.APP5= HM.REC5<EB.SystemTables.HelptextMenu.MenApplication>
    FOR M=1 TO DCOUNT(Y.HM.APP5,VM)
        EB.DataAccess.FRead(FN.VER, FIELD(Y.HM.APP5<1,M>,' ',1), VER.REC5, F.VER, VER.ERR5)
        Y.PART5.1= FIELD(Y.HM.APP5<1,M>,' ',1)
        Y.PART5.2= FIELD(Y.HM.APP5<1,M>,' ',2)
        EB.DataAccess.FRead(FN.HM, Y.HM.APP5<1,M>, HM.REC5.1, F.HM, HM.ERR5.1)
        BEGIN CASE
            CASE Y.PART5.1 EQ 'ENQ' OR Y.PART5.1 EQ 'QUERY'
                WriteData<-1>='ENQUIRY>':Y.PART5.2
                EB.DataAccess.FRead(FN.ENQ, Y.PART5.2, ENQ.REC5, F.ENQ, ENQ.ERR)
                Y.ENQ.FLD.NAME5=ENQ.REC5<EB.Reports.Enquiry.EnqFileName>
                IF FIELD(Y.ENQ.FLD.NAME5,'.',1) EQ 'NOFILE' THEN
                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME5
                END
                Y.ENQ.RTN=ENQ.REC5<EB.Reports.Enquiry.EnqBuildRoutine>
                GOSUB WRITERTN2
                Y.CONV.RTN=ENQ.REC5<EB.Reports.Enquiry.EnqConversion>
                GOSUB WRITERTN3
            CASE Y.PART5.1 EQ 'COS'
                WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.PART5.2
                EB.DataAccess.FRead(FN.COS, Y.PART5.2, COS.REC5, F.COS, COS.ERR)
                Y.COS.CONT.TYPE5=COS.REC5<EB.SystemTables.CompositeScreen.CsContentType>
                Y.COS.CONT5=COS.REC5<EB.SystemTables.CompositeScreen.CsContent>
                FOR MM=1 TO DCOUNT(Y.COS.CONT.TYPE5,VM)
                    IF Y.COS.CONT.TYPE5<1,MM> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT5<1,MM>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT5<1,MM>,' ',1), ENQ.REC5.2, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME5.2=ENQ.REC5.2<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME5.2,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME5.2
                        END
                        Y.ENQ.RTN=ENQ.REC5.2<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC5.2<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.COS.CONT.TYPE5<1,MM> EQ 'TAB' THEN
                        WriteData<-1>='EB.TABBED.SCREEN>':Y.COS.CONT5<1,MM>
                        EB.DataAccess.FRead(FN.TAB, Y.COS.CONT5<1,MM>, TAB.REC5, F.TAB, TAB.ERR)
                        Y.TAB.CONT.TYPE5=TAB.REC5<EB.SystemTables.TabbedScreen.TsContentType>
                        Y.TAB.SRC5=TAB.REC5<EB.SystemTables.TabbedScreen.TsSource>
                        FOR MM5.2=1 TO DCOUNT(Y.TAB.CONT.TYPE5,VM)
                            IF Y.TAB.CONT.TYPE5<1,MM5.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC5<1,MM5.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC5<1,MM5.2>,' ',1), ENQ.REC5.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME5.3=ENQ.REC5.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME5.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME5.3
                                END
                                Y.ENQ.RTN=ENQ.REC5.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC5.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT MM5.2
                    END
                NEXT MM
            CASE Y.PART5.1 EQ 'TAB'
                WriteData<-1>='EB.TABBED.SCREEN>':Y.PART5.2
                EB.DataAccess.FRead(FN.TAB, Y.PART5.2, TAB.REC5.2, F.TAB, TAB.ERR)
                Y.TAB.CONT.TYPE5=TAB.REC5.2<EB.SystemTables.TabbedScreen.TsContentType>
                Y.TAB.SRC5=TAB.REC5.2<EB.SystemTables.TabbedScreen.TsSource>
                FOR MM=1 TO DCOUNT(Y.TAB.CONT.TYPE5,VM)
                    IF Y.TAB.CONT.TYPE5<1,MM> EQ 'ENQ' THEN
                        WriteData<-1>='ENQUIRY>':FIELD(Y.TAB.SRC5<1,MM>,' ',1)
                        EB.DataAccess.FRead(FN.ENQ, FIELD(Y.TAB.SRC5<1,MM>,' ',1), ENQ.REC5.3, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME5.3=ENQ.REC5.3<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME5.3,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME5.3
                        END
                        Y.ENQ.RTN=ENQ.REC5.3<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC5.3<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                    IF Y.TAB.CONT.TYPE5<1,MM> EQ 'COS' THEN
                        WriteData<-1>='EB.COMPOSITE.SCREEN>':Y.TAB.SRC5<1,MM>
                        EB.DataAccess.FRead(FN.COS, Y.TAB.SRC5<1,MM>, COS.REC5.2, F.COS, COS.ERR)
                        Y.COS.CONT.TYPE5.2=COS.REC5.2<EB.SystemTables.CompositeScreen.CsContentType>
                        Y.COS.CONT5.2=COS.REC5.2<EB.SystemTables.CompositeScreen.CsContent>
                        FOR MM5.2=1 TO DCOUNT(Y.COS.CONT.TYPE5.2,VM)
                            IF Y.COS.CONT.TYPE5.2<1,MM5.2> EQ 'ENQ' THEN
                                WriteData<-1>='ENQUIRY>':FIELD(Y.COS.CONT5.2<1,MM5.2>,' ',1)
                                EB.DataAccess.FRead(FN.ENQ, FIELD(Y.COS.CONT5.2<1,MM5.2>,' ',1), ENQ.REC5.3, F.ENQ, ENQ.ERR)
                                Y.ENQ.FLD.NAME5.3=ENQ.REC5.3<EB.Reports.Enquiry.EnqFileName>
                                IF FIELD(Y.ENQ.FLD.NAME5.3,'.',1) EQ 'NOFILE' THEN
                                    WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME5.3
                                END
                                Y.ENQ.RTN=ENQ.REC5.3<EB.Reports.Enquiry.EnqBuildRoutine>
                                GOSUB WRITERTN2
                                Y.CONV.RTN=ENQ.REC5.3<EB.Reports.Enquiry.EnqConversion>
                                GOSUB WRITERTN3
                            END
                        NEXT MM5.2
                    END
                NEXT MM
            CASE VER.REC5 NE ''
                WriteData<-1>='VERSION>':FIELD(Y.HM.APP5<1,M>,' ',1)
                Y.VER.ENQ5=VER.REC5<EB.Versions.Version.VerDropDown>
                FOR MM=1 TO DCOUNT(Y.VER.ENQ5,VM)
                    IF Y.VER.ENQ4<1,MM> NE '' THEN
                        WriteData<-1>='ENQUIRY>':Y.VER.ENQ5<1,MM>
                        EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ5<1,MM>, ENQ.REC5.4, F.ENQ, ENQ.ERR)
                        Y.ENQ.FLD.NAME5.4=ENQ.REC5.4<EB.Reports.Enquiry.EnqFileName>
                        IF FIELD(Y.ENQ.FLD.NAME5.4,'.',1) EQ 'NOFILE' THEN
                            WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME5.4
                        END
                        Y.ENQ.RTN=ENQ.REC5.4<EB.Reports.Enquiry.EnqBuildRoutine>
                        GOSUB WRITERTN2
                        Y.CONV.RTN=ENQ.REC5.4<EB.Reports.Enquiry.EnqConversion>
                        GOSUB WRITERTN3
                    END
                NEXT MM
                Y.VER.FLD5=VER.REC5<EB.Versions.Version.VerFieldNo>
                FOR MM=1 TO DCOUNT(Y.VER.FLD5,VM)
                    IF Y.VER.FLD5<1,MM> NE '' AND FIELD(Y.VER.FLD5<1,MM>,'.',1) EQ 'LT' THEN
                        WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD5<1,MM>,'-',1)
                        WriteOther<-1>=FIELD(Y.HM.APP5<1,M>,',',1):'>>>':FIELD(Y.VER.FLD5<1,MM>,'-',1)
                    END
                NEXT MM
                Y.VER.RTN=VER.REC5<EB.Versions.Version.VerValidationRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC5<EB.Versions.Version.VerInputRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC5<EB.Versions.Version.VerAuthRoutine>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC5<EB.Versions.Version.VerIdRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC5<EB.Versions.Version.VerCheckRecRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC5<EB.Versions.Version.VerBeforeAuthRtn>
                GOSUB WRITERTN
                Y.VER.RTN=VER.REC5<EB.Versions.Version.VerAfterUnauRtn>
                GOSUB WRITERTN
                Y.VER.ASSO.VER5=VER.REC5<EB.Versions.Version.VerAssocVersion>
                FOR MM=1 TO DCOUNT(Y.VER.ASSO.VER5,VM)
                    WriteData<-1>='VERSION>':Y.VER.ASSO.VER5<1,MM>
                    EB.DataAccess.FRead(FN.VER, Y.VER.ASSO.VER5<1,MM>, ASSO.REC5, F.VER, ASSO.ERR)
                    Y.VER.ENQ5=ASSO.REC5<EB.Versions.Version.VerDropDown>
                    FOR MM5.2=1 TO DCOUNT(Y.VER.ENQ5,VM)
                        IF Y.VER.ENQ5<1,MM5.2> NE '' THEN
                            WriteData<-1>='ENQUIRY>':Y.VER.ENQ5<1,MM5.2>
                            EB.DataAccess.FRead(FN.ENQ, Y.VER.ENQ5<1,MM5.2>, ENQ.REC5.4, F.ENQ, ENQ.ERR)
                            Y.ENQ.FLD.NAME5.4=ENQ.REC5.4<EB.Reports.Enquiry.EnqFileName>
                            IF FIELD(Y.ENQ.FLD.NAME5.4,'.',1) EQ 'NOFILE' THEN
                                WriteData<-1>='STANDARD.SELECTION>':Y.ENQ.FLD.NAME5.4
                            END
                            Y.ENQ.RTN=ENQ.REC5.4<EB.Reports.Enquiry.EnqBuildRoutine>
                            GOSUB WRITERTN2
                            Y.CONV.RTN=ENQ.REC5.4<EB.Reports.Enquiry.EnqConversion>
                            GOSUB WRITERTN3
                        END
                    NEXT MM5.2
                    Y.VER.FLD5=ASSO.REC5<EB.Versions.Version.VerFieldNo>
                    FOR MM5.2=1 TO DCOUNT(Y.VER.FLD5,VM)
                        IF Y.VER.FLD5<1,MM5.2> NE '' AND FIELD(Y.VER.FLD5<1,MM5.2>,'.',1) EQ 'LT' THEN
                            WriteLT<-1>='LOCAL.TABLE>':FIELD(Y.VER.FLD5<1,MM5.2>,'-',1)
                            WriteOther<-1>=FIELD(Y.VER.ASSO.VER5<1,MM>,',',1):'>>>':FIELD(Y.VER.FLD5<1,MM5.2>,'-',1)
                        END
                    NEXT MM5.2
                    Y.VER.RTN=ASSO.REC5<EB.Versions.Version.VerValidationRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC5<EB.Versions.Version.VerInputRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC5<EB.Versions.Version.VerAuthRoutine>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC5<EB.Versions.Version.VerIdRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC5<EB.Versions.Version.VerCheckRecRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC5<EB.Versions.Version.VerBeforeAuthRtn>
                    GOSUB WRITERTN
                    Y.VER.RTN=ASSO.REC5<EB.Versions.Version.VerAfterUnauRtn>
                    GOSUB WRITERTN
                NEXT MM
            CASE HM.REC5.1 NE ''
                WriteData<-1>='HELPTEXT.MENU>':Y.HM.APP5<1,M>
*                Y.HM.6=Y.HM.APP5<1,M>
*                GOSUB MENU6
        END CASE
    NEXT M
RETURN

WRITERTN:
    IF DCOUNT(Y.VER.RTN,VM) EQ 0 THEN
        RETURN
    END
    FOR Z=1 TO DCOUNT(Y.VER.RTN,VM)
        WriteData<-1> = 'EB.API>':Y.VER.RTN<1,Z>
        WriteOther<-1> = 'RTN>>>':Y.VER.RTN<1,Z>
        EB.DataAccess.FRead(FN.PF, Y.VER.RTN<1,Z>, PF.REC, F.PF, PF.ERR)
        IF PF.REC NE '' THEN
            WriteData<-1> = 'PGM.FILE>':Y.VER.RTN<1,Z>
        END
    NEXT Z
RETURN
WRITERTN2:
    IF DCOUNT(Y.ENQ.RTN,VM) EQ 0 THEN
        RETURN
    END
    FOR Z=1 TO DCOUNT(Y.ENQ.RTN,VM)
        WriteOther<-1> = 'RTN>>>':Y.ENQ.RTN<1,Z>
    NEXT Z
RETURN
WRITERTN3:
    IF DCOUNT(Y.CONV.RTN,VM) EQ 0 THEN
        RETURN
    END
    FOR Z=1 TO DCOUNT(Y.CONV.RTN,VM)
        IF FIELD(Y.CONV.RTN<1,Z>,' ',1) EQ '@' THEN
            WriteOther<-1> = 'RTN>>>':FIELD(Y.CONV.RTN<1,Z>,' ',2)
        END
    NEXT Z
RETURN
END
