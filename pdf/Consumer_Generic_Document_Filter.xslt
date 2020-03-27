<?xml version="1.0" encoding="UTF-8"?>
<!-- Consumer Generic Stylesheet v1.2.8a -->
<!--
    Copyright 2013 NEHTA
   
    Production Disclaimer - 

    NEHTA (as Licensor) grants You a licence to this Product subject to 
    the terms of the Apache Licence (version 2.0), a copy of which is 
    available at http://www.apache.org/licenses/LICENSE-2.0, and the 
    following terms.
     
    This Product licensed under the Apache Licence and these terms may
    be used within production software systems. It nevertheless remains 
    your responsibility to test and validate the use of this product 
    within your software and the limitation of liability provisions in 
    clause 8 of the Apache Licence continue to apply.
    
    Despite clause 7 of the Apache Licence, if a condition or warranty 
    is implied by statute or law that cannot be excluded, then the 
    liability of a Contributor to the extent that it has contributed to 
    a breach of that condition or warranty is limited to one or more of 
    the following at its option: (a) in the case of goods, any one of 
    the following: the replacement of those goods or the re-supply of 
    equivalent goods; the repair of those goods; the payment of the 
    cost of replacing those or acquiring equivalent goods; or the 
    payment of the cost of having those goods repaired; and (b) in the 
    case of services: the supplying of those services again; or the 
    payment of the cost of having those services supplied again.
     
    A term which is given a meaning in the Apache Licence, has the same 
    meaning when used in these terms.
    
    Revision History:
    
    Version 1.2.8a | 05/05/2015
    - Fixed the issue where stylesheet uses CDA attributes without sanitisation
    - Fixed the issue to prevent Javascript injection
    - Fixed the issue to prevent styleCode attributes injection

    Version 1.2.8 | 22/10/2013
    - Fixed bug in nestedSection template
    - Fixed author name bug at start of document
    - Added parameter to disable rendering of the Administrative Observations section (defaults to always displaying it)
    - Fixed td and th templates to correctly assign generic CSS styles when an 'ID' attribute is present
    - Added Banner CSS styles to support Microsoft Internet Explorer 6
    - Added status of withdrawn documents to the banner
    - Added Street Suffix, Postal Delivery Type, Postal Delivery Number, Australian Unit Number and Australian Unit Type
      to display of addresses
    - Administrative Observations section will only be rendered if the narrative block <text> element is present in the section
    - Removed page-break-inside: avoid CSS property throughout
    
    Version 1.2.7 | 22/12/2012
    - Fixed footnoteRef bug
    - Removed commented out code in cda:footnote template

    Version 1.2.6 | 11/12/2012
    - Updated linkHtml to support observationMedia internal targets and external targets
      (i.e. those without an XML ID e.g. a file in the package or external URL)
    - Added PCEHR Prescription and Dispense View document type recognition
    - Ensured consistent date/datetime date/month/year separators when formatting dates
    - Changed formatting of patient name in the banner

    Version 1.2.5 | 3/10/2012
    - Included Author Organisation and Author Department in administrative details      

    Version 1.2.4 | 27/09/2012
    - Amended display of document, set, and related identifiers      
    - Removed display of PCEHR Prescription Record and PCEHR Dispense Record
      item identifiers in Administrative Details

    Version 1.2.3 | 14/09/2012
    - Added printing of the Black Banner on the first page
    - Trimmed the content of the HTML title for printing
    - Fixed top left margin alignment for xPre text
    - Added param to support displaying style sheet version
    
    Version 1.2.2 | 3/09/2012
    - Added PCEHR Prescription Record and PCEHR Dispense Record document type recognition
    - Removed default paragraph width CSS attributes to allow nest paragraphs
    
    Version 1.2.1 | 31/08/2012
    - Corrected "Medicare/DVA Benefits Report" document type name
    - Fixed section header attribute bug
    
    Version 1.2.0 | 21/08/2012
    - Initial version 
-->


<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cda="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:ext="http://ns.electronichealth.net.au/Ci/Cda/Extensions/3.0"
                exclude-result-prefixes="xsi cda ext">
    
    <!-- PARAMETERS -->
    <xsl:param name="providerIndividualIdentifierDisplay">false</xsl:param>
    <xsl:param name="providerOrganisationIdentifierDisplay">false</xsl:param>
    <xsl:param name="providerDeviceIdentifierDisplay">false</xsl:param>
    <xsl:param name="styleSheetVersionDisplay">false</xsl:param>
    <xsl:param name="administrativeObservationsSectionDisplay">true</xsl:param>
    
    
    <!-- OUTPUT -->
    <!--================================================================================================================================================================================-->
<!--    <xsl:output method="html" indent="yes" version="4.01" encoding="UTF-8"
                doctype-system="http://www.w3.org/TR/html4/strict.dtd"
                doctype-public="-//W3C//DTD HTML 4.01//EN"/>-->
    <!--================================================================================================================================================================================-->
    <!-- [END] OUTPUT -->


    <!-- Modification by Accenture -->
    <!-- Orion Health cViewer variables. Note the "angle-bracket percent" syntax is illegal in XSL and is actually cViewer template processor syntax. It must be removed if testing the style sheet outside cViewer -->
 
    <xsl:variable name="relationship">Consumer</xsl:variable>
    <xsl:variable name="documentType">Specialist Letter</xsl:variable>
    <xsl:variable name="isReadOnlyActivated">N</xsl:variable>
    <xsl:variable name="resourcePath">https://myrecord.ehealthdev.health.gov.au/static/20130424</xsl:variable>
    <xsl:variable name="activateAlertMessage">hghghg</xsl:variable>
    <xsl:variable name="repoId"></xsl:variable>
    <xsl:variable name="pcehrDocumentId"></xsl:variable>
    <xsl:variable name="cViewerAttachmentPrefix" select="'/ncp/getPDFContent?'"/>
    <xsl:variable name="cViewerPDFAttachmentPrefix" select="'/ncp/getPDFImages?'"></xsl:variable>
    <xsl:variable name="userAgent">IE</xsl:variable>

    <xsl:variable name="GENERIC_VIEW_RESOURCE_PATH"><xsl:value-of select="$resourcePath"/>/GenericXSLT/</xsl:variable>
    
    <!-- CDB Changes -->
    <xsl:variable name="CDB_08_MEDICARE_A">Medicare</xsl:variable>
    
    <!-- [END] Modification by Accenture -->

    <!-- CONSTANTS -->
    <!--================================================================================================================================================================================-->
    <!-- NEHTA CDA Rendering Specification Object Identifier -->
    <xsl:variable name="NEHTA_CDA_RENDERING_SPECIFICATION_OID">1.2.36.1.2001.1001.100.149</xsl:variable>
    
    <!-- Version of the NEHTA Generic CDA Stylesheet -->
    <xsl:variable name="NEHTA_GENERIC_CDA_STYLESHEET_VERSION">1.2.8</xsl:variable>
    
    <!-- Version note -->
    <xsl:variable name="VERSION_NOTE">HTML Generated by the NEHTA Generic CDA Stylesheet Version: <xsl:value-of select="$NEHTA_GENERIC_CDA_STYLESHEET_VERSION"/> </xsl:variable>

    <!-- Do note edit note -->
    <xsl:variable name="DO_NOT_EDIT_NOTE">Do NOT edit this HTML directly: it was generated via an XSLT transformation from a source CDA Release 2 XML document.</xsl:variable>

    <!-- CDA Rendering Specification Incompatibility Warning -->
    <xsl:variable name="CDA_RENDERING_SPECIFICATION_INCOMPATIBILITY_WARNING">The document you are about to view is newer than this software was designed to display. The document may not be fully displayed as the original author intended.</xsl:variable>

    <!-- Provider Identifier CSS Classes -->
    <xsl:variable name="PROVIDER_INDIVIDUAL_IDENTIFIER_CSS_CLASS">PROVIDER_INDIVIDUAL_IDENTIFIER</xsl:variable>
    <xsl:variable name="PROVIDER_ORGANISATION_IDENTIFIER_CSS_CLASS">PROVIDER_ORGANISATION_IDENTIFIER</xsl:variable>
    <xsl:variable name="PROVIDER_DEVICE_IDENTIFIER_CSS_CLASS">PROVIDER_DEVICE_IDENTIFIER</xsl:variable>
    
    <!-- Version of the NEHTA CDA Rendering Specification supported by the stylesheet -->
    <xsl:variable name="NEHTA_GENERIC_CDA_STYLESHEET_SUPPORTED_CDA_RENDERING_SPECIFICATION_VERSION">1.0</xsl:variable>
    <xsl:variable name="NEHTA_GENERIC_CDA_STYLESHEET_SUPPORTED_CDA_RENDERING_SPECIFICATION_MAJOR_VERSION" select="substring-before($NEHTA_GENERIC_CDA_STYLESHEET_SUPPORTED_CDA_RENDERING_SPECIFICATION_VERSION, '.')"/>
    <xsl:variable name="NEHTA_GENERIC_CDA_STYLESHEET_SUPPORTED_CDA_RENDERING_SPECIFICATION_MINOR_VERSION" select="substring-after($NEHTA_GENERIC_CDA_STYLESHEET_SUPPORTED_CDA_RENDERING_SPECIFICATION_VERSION, '.')"/>

    <!-- NEHTA CDA Implementation Guide Object Identifiers -->
    <xsl:variable name="NEHTA_DISCHARGE_SUMMARY_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.4</xsl:variable>
    <xsl:variable name="NEHTA_SHARED_HEALTH_SUMMARY_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.120</xsl:variable>
    <xsl:variable name="NEHTA_E_REFERRAL_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.2</xsl:variable>
    <xsl:variable name="NEHTA_SPECIALIST_LETTER_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.132</xsl:variable>
    <xsl:variable name="NEHTA_EVENT_SUMMARY_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.136</xsl:variable>
    <xsl:variable name="NEHTA_E_PRESCRIPTION_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.74</xsl:variable>
    <xsl:variable name="NEHTA_DISPENSE_RECORD_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.75</xsl:variable>
    <xsl:variable name="NEHTA_PRESCRIPTION_REQUEST_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.101</xsl:variable>
    <xsl:variable name="NEHTA_AUSTRALIAN_CHILDHOOD_IMMUNISATION_REGISTER_RECORD_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.144</xsl:variable>
    <xsl:variable name="NEHTA_AUSTRALIAN_ORGAN_DONOR_REGISTER_RECORD_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.147</xsl:variable>
    <xsl:variable name="NEHTA_MEDICARE_DVA_BENEFITS_REPORT_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.140</xsl:variable>
    <xsl:variable name="NEHTA_ADVANCE_CARE_DIRECTIVE_CUSTODIAN_RECORD_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.156</xsl:variable>
    <xsl:variable name="NEHTA_PHARMACEUTICAL_BENEFITS_REPORT_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.142</xsl:variable>
    <xsl:variable name="NEHTA_CONSUMER_ENTERED_NOTES_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.151</xsl:variable>
    <xsl:variable name="NEHTA_CONSUMER_ENTERED_HEALTH_SUMMARY_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.153</xsl:variable>
    <xsl:variable name="NEHTA_CONSOLIDATED_VIEW_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.101.100.1002.160</xsl:variable>
    <xsl:variable name="NEHTA_MEDICARE_INFORMATION_VIEW_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.100.1002.172</xsl:variable>
    <xsl:variable name="NEHTA_PCEHR_PRESCRIPTION_RECORD_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.100.1002.170</xsl:variable>
    <xsl:variable name="NEHTA_PCEHR_DISPENSE_RECORD_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.100.1002.171</xsl:variable>
    <xsl:variable name="NEHTA_PCEHR_PRESCRIPTION_AND_DISPENSE_VIEW_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.100.1002.179</xsl:variable>
    <!-- Variable added for Path and DI (Modification by Accenture) -->
    <xsl:variable name="NEHTA_PATHOLOGY_REPORT_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.100.1002.220</xsl:variable>
    <xsl:variable name="NEHTA_DIAGNOSTIC_IMAGING_REPORT_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.100.1002.222</xsl:variable>
    <!-- [END] Variable added for Path and DI (Modification by Accenture) -->

    <!-- Variable added for ACI (Modification by Accenture) -->
    <xsl:variable name="NEHTA_ADVANCE_CARE_INFORMATION_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.100.1002.226</xsl:variable>
    <xsl:variable name="NEHTA_PHARMACIST_CURATED_MEDICINES_LIST_CDA_IMPLEMENTATION_GUIDE_OID">1.2.36.1.2001.1001.100.1002.237</xsl:variable>
    <!-- [END] Variable added for ACI (Modification by Accenture) -->
    

    <!-- Page widths and heights -->
    <xsl:variable name="FULL_VIEWPORT_WIDTH_PX">1024</xsl:variable>
    <xsl:variable name="TOP_MARGIN_WIDTH_PX">4</xsl:variable>
    <xsl:variable name="LEFT_MARGIN_WIDTH_PX">10</xsl:variable>
    <xsl:variable name="RIGHT_MARGIN_WIDTH_PX">10</xsl:variable>
    <xsl:variable name="CONTENT_SCROLL_BAR_WIDTH_PX">30</xsl:variable>

    <xsl:variable name="FULL_CONTENT_WIDTH_PX">1000</xsl:variable>
    <xsl:variable name="MINIMUM_CONTENT_WIDTH_PX">740</xsl:variable>
    <xsl:variable name="HALF_CONTENT_WIDTH_PX" select="$FULL_CONTENT_WIDTH_PX div 2"/>
    <xsl:variable name="FIFTH_CONTENT_WIDTH_PX" select="$FULL_CONTENT_WIDTH_PX div 5"/>
    <xsl:variable name="QUARTER_CONTENT_WIDTH_PX" select="$FULL_CONTENT_WIDTH_PX div 4"/>
    <xsl:variable name="EIGHTH_CONTENT_WIDTH_PX" select="$FULL_CONTENT_WIDTH_PX div 8"/>
    <xsl:variable name="TENTH_CONTENT_WIDTH_PX" select="$FULL_CONTENT_WIDTH_PX div 10"/>
    <xsl:variable name="THREE_QUARTER_CONTENT_WIDTH_PX" select="($FULL_CONTENT_WIDTH_PX div 4) * 3"/>
    
    <xsl:variable name="FULL_CONTENT_WIDTH_PCT">100</xsl:variable>
    <xsl:variable name="HALF_CONTENT_WIDTH_PCT">50</xsl:variable>
    <xsl:variable name="FIFTH_CONTENT_WIDTH_PCT">20</xsl:variable>
    <xsl:variable name="QUARTER_CONTENT_WIDTH_PCT">25</xsl:variable>
    <xsl:variable name="EIGHTH_CONTENT_WIDTH_PCT">12.5</xsl:variable>
    <xsl:variable name="TENTH_CONTENT_WIDTH_PCT">10</xsl:variable>
    <xsl:variable name="THREE_QUARTER_CONTENT_WIDTH_PCT">75</xsl:variable>

    <xsl:variable name="DETAILS_HALF_TABLE_TH_WIDTH_PCT">35</xsl:variable>
    <xsl:variable name="DETAILS_HALF_TABLE_TD_WIDTH_PCT" select="100 - $DETAILS_HALF_TABLE_TH_WIDTH_PCT"/>
    

    <xsl:variable name="AKA_STRING">a.k.a. </xsl:variable>
    <xsl:variable name="SECTION_TITLE_NAVIGATION_SEPARATOR" select="' > '"/>
    
    <!-- Colours -->
    <xsl:variable name="GENERAL_TABLE_HEADER_CELL_BACKGROUND_COLOUR">#FFFFFF</xsl:variable>
    <xsl:variable name="GENERAL_TABLE_HEADER_CELL_BORDER_COLOUR">#EEEEEE</xsl:variable>
    
    <!--================================================================================================================================================================================-->
    <!-- [END] CONSTANTS -->




    <!-- GLOBAL VARIABLES -->
    <!--================================================================================================================================================================================-->
    <xsl:variable name="cdaDocumentCdaRenderingSpecificationVersion" select="/cda:ClinicalDocument/cda:templateId[@root='1.2.36.1.2001.1001.100.149']/@extension"/>
    <xsl:variable name="cdaDocumentCdaRenderingSpecificationMajorVersionNumber" select="substring-before($cdaDocumentCdaRenderingSpecificationVersion, '.')"></xsl:variable>
    <xsl:variable name="cdaDocumentCdaRenderingSpecificationMinorVersionNumber" select="substring-after($cdaDocumentCdaRenderingSpecificationVersion, '.')"></xsl:variable>
    <xsl:variable name="isStylesheetCompatibleWithRequiredRenderingSpecificationVersion">
        <xsl:choose>
            <xsl:when test="string-length($cdaDocumentCdaRenderingSpecificationVersion) &gt; 0">
                <xsl:choose>
                    <xsl:when test="$cdaDocumentCdaRenderingSpecificationMajorVersionNumber &gt; $NEHTA_GENERIC_CDA_STYLESHEET_SUPPORTED_CDA_RENDERING_SPECIFICATION_MAJOR_VERSION">false</xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$cdaDocumentCdaRenderingSpecificationMajorVersionNumber = $NEHTA_GENERIC_CDA_STYLESHEET_SUPPORTED_CDA_RENDERING_SPECIFICATION_MAJOR_VERSION">
                                <xsl:choose>
                                    <xsl:when test="$cdaDocumentCdaRenderingSpecificationMinorVersionNumber &gt; $NEHTA_GENERIC_CDA_STYLESHEET_SUPPORTED_CDA_RENDERING_SPECIFICATION_MINOR_VERSION">false</xsl:when>
                                    <xsl:otherwise>true</xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>true</xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>true</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
       
    <!-- Patient Details -->
    <xsl:variable name="patientIHI">
       <xsl:call-template name="trim">
           <xsl:with-param name="string">
               <xsl:call-template name="formatHI">
                   <xsl:with-param name="hiValue" select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:asEntityIdentifier/ext:id[@assigningAuthorityName='IHI']/@root"/>
                </xsl:call-template>
           </xsl:with-param>
       </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="patientMRN">
        <xsl:if test="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id/@extension and 
            not (/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id/@displayable='false')">
            <xsl:value-of select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:asEntityIdentifier[ext:code/@code='MR']/ext:id/@extension"/>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="patientFamilyName">
        <xsl:call-template name="toUpperCase">
            <xsl:with-param name="data"  select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name[1]/cda:family"/> 
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="patientGivenName" select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name[1]/cda:given"/>
    <xsl:variable name="patientPrefix" select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name[1]/cda:prefix"/>
    
    <xsl:variable name="patientName">
        <xsl:call-template name="show-patient-name">
            <xsl:with-param name="name"
                select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name[1]"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="patientDateOfBirth">
        <xsl:call-template name="show-date">
            <xsl:with-param name="datetime"
                select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:birthTime"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="patientDeceasedStatus">
        <xsl:choose>
            <xsl:when test="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:deceasedInd and
                /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:deceasedInd/@value and
                /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:deceasedInd/@value='true'">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="patientCodedAge">
        <xsl:call-template name="getCodedAge">
            <xsl:with-param name="ageValue">
                <xsl:choose>
                    <xsl:when test="string-length(/cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:observation[cda:code/@code='103.20109' and cda:code/@codeSystem='1.2.36.1.2001.1001.101']/cda:value/@value) &gt; 0">
                        <xsl:value-of select="/cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:observation[cda:code/@code='103.20109' and cda:code/@codeSystem='1.2.36.1.2001.1001.101']/cda:value/@value" />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="ageUcumUnitCode">
                <xsl:choose>
                    <xsl:when test="string-length(/cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:observation[cda:code/@code='103.20109' and cda:code/@codeSystem='1.2.36.1.2001.1001.101']/cda:value/@unit) &gt; 0">
                        <xsl:value-of select="/cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:observation[cda:code/@code='103.20109' and cda:code/@codeSystem='1.2.36.1.2001.1001.101']/cda:value/@unit" />
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>    
    
    <xsl:variable name="patientAge">
        <xsl:choose>
            <xsl:when test="$patientDeceasedStatus='true'">DECEASED</xsl:when>
            <xsl:when test="string-length($patientCodedAge) &gt; 0">
                <xsl:value-of select="$patientCodedAge"/>
            </xsl:when>
            <xsl:when test="((string-length(/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:birthTime/@value) &gt; 7) and
                                 ((string-length(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value) &gt; 7) or
                                  (string-length(/cda:ClinicalDocument/cda:effectiveTime/@value) &gt; 7)
                                 )
                             )">
                <xsl:call-template name="calculateAge">
                    <xsl:with-param name="birthDate">
                        <xsl:value-of select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:birthTime/@value"/>
                    </xsl:with-param>
                    <xsl:with-param name="docDate">
                        <xsl:choose>
                            <xsl:when test="string-length(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value) &gt; 0">
                                <xsl:value-of select="substring(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value,1,8)" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(/cda:ClinicalDocument/cda:effectiveTime/@value,1,8)" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>AGE UNKNOWN</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>    
    
    <xsl:variable name="patientSex">
        <xsl:if test="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode and
                      /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode/@code and
                      string-length(/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode/@code) &gt; 0 and
                      /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode/@codeSystem='2.16.840.1.113883.13.68'">
            <xsl:choose>
                <xsl:when test="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode/@code = 'M'">Male</xsl:when>
                <xsl:when test="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode/@code = 'F'">Female</xsl:when>
                <xsl:when test="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode/@code = 'I'">Intersex or Indeterminate</xsl:when>
                <xsl:when test="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:administrativeGenderCode/@code = 'N'">Not Stated/Inadequately Described</xsl:when>
                <xsl:otherwise>Unknown</xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:variable>
     
    <xsl:variable name="patientIndigenousStatus">
        <xsl:if test="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode/@code and
                      (string-length(/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode/@code) &gt; 0) and
                      /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode/@codeSystem='2.16.840.1.113883.3.879.291036' and
                      /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode/@displayName and
                      (string-length(/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode/@displayName) &gt; 0)">
            <xsl:value-of select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:ethnicGroupCode/@displayName"/>
        </xsl:if>
    </xsl:variable>
    
    <!-- Discharge Details -->
    <xsl:variable name="dischargeLocation">
        <xsl:if test="/cda:ClinicalDocument/cda:participant[@typeCode='ORG' and cda:associatedEntity/@classCode='SDLOC']/cda:associatedEntity/cda:code/cda:originalText and
            string-length(/cda:ClinicalDocument/cda:participant[@typeCode='ORG' and cda:associatedEntity/@classCode='SDLOC']/cda:associatedEntity/cda:code/cda:originalText) &gt; 0">
            <xsl:value-of select="/cda:ClinicalDocument/cda:participant[@typeCode='ORG' and cda:associatedEntity/@classCode='SDLOC']/cda:associatedEntity/cda:code/cda:originalText"/>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="separationMode" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:dischargeDispositionCode/@displayName"/>
     
    <!-- CDA Document Type -->
    <xsl:variable name="cdaDocumentType">
        <xsl:choose>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_DISCHARGE_SUMMARY_CDA_IMPLEMENTATION_GUIDE_OID]">e-Discharge Summary</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_SHARED_HEALTH_SUMMARY_CDA_IMPLEMENTATION_GUIDE_OID]">Shared Health Summary</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_E_REFERRAL_CDA_IMPLEMENTATION_GUIDE_OID]">e-Referral</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_SPECIALIST_LETTER_CDA_IMPLEMENTATION_GUIDE_OID]">Specialist Letter</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_EVENT_SUMMARY_CDA_IMPLEMENTATION_GUIDE_OID]">Event Summary</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_E_PRESCRIPTION_CDA_IMPLEMENTATION_GUIDE_OID]">e-Prescription</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_DISPENSE_RECORD_CDA_IMPLEMENTATION_GUIDE_OID]">Dispense Record</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PRESCRIPTION_REQUEST_CDA_IMPLEMENTATION_GUIDE_OID]">Prescription Request</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_AUSTRALIAN_CHILDHOOD_IMMUNISATION_REGISTER_RECORD_CDA_IMPLEMENTATION_GUIDE_OID]">Australian Childhood Immunisation Register Record</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_AUSTRALIAN_ORGAN_DONOR_REGISTER_RECORD_CDA_IMPLEMENTATION_GUIDE_OID]">Australian Organ Donor Register Record</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_MEDICARE_DVA_BENEFITS_REPORT_CDA_IMPLEMENTATION_GUIDE_OID]">Medicare/DVA Benefits Report</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PHARMACEUTICAL_BENEFITS_REPORT_CDA_IMPLEMENTATION_GUIDE_OID]">Pharmaceutical Benefits Report</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_ADVANCE_CARE_DIRECTIVE_CUSTODIAN_RECORD_CDA_IMPLEMENTATION_GUIDE_OID]">Advance Care Directive Custodian Record</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_CONSUMER_ENTERED_NOTES_CDA_IMPLEMENTATION_GUIDE_OID]">Consumer Entered Notes</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_CONSUMER_ENTERED_HEALTH_SUMMARY_CDA_IMPLEMENTATION_GUIDE_OID]">Consumer Entered Health Summary</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_CONSOLIDATED_VIEW_CDA_IMPLEMENTATION_GUIDE_OID]">Consolidated View</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_MEDICARE_INFORMATION_VIEW_CDA_IMPLEMENTATION_GUIDE_OID]">Medicare Information View</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PCEHR_PRESCRIPTION_RECORD_CDA_IMPLEMENTATION_GUIDE_OID]">eHealth Prescription Record</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PCEHR_DISPENSE_RECORD_CDA_IMPLEMENTATION_GUIDE_OID]">eHealth Dispense Record</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PCEHR_PRESCRIPTION_AND_DISPENSE_VIEW_CDA_IMPLEMENTATION_GUIDE_OID]">PCEHR Prescription and Dispense View</xsl:when>
            <!-- Check added for Path and DI (Modification by Accenture) -->
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PATHOLOGY_REPORT_CDA_IMPLEMENTATION_GUIDE_OID]">Pathology Report</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_DIAGNOSTIC_IMAGING_REPORT_CDA_IMPLEMENTATION_GUIDE_OID]">Diagnostic Imaging Report</xsl:when>
            <!-- [END] Check added for Path and DI (Modification by Accenture) -->
			
			<!-- Check added for ACI (Modification by Accenture) -->
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_ADVANCE_CARE_INFORMATION_CDA_IMPLEMENTATION_GUIDE_OID]">Advance Care Information</xsl:when>
            <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PHARMACIST_CURATED_MEDICINES_LIST_CDA_IMPLEMENTATION_GUIDE_OID]">Pharmacist Shared Medicines List</xsl:when>
            <!-- [END] Check added for ACI (Modification by Accenture) -->
			
            <xsl:when test="/cda:ClinicalDocument/cda:code/@displayName and
                            string-length(/cda:ClinicalDocument/cda:code/@displayName) &gt; 0">
                <xsl:value-of select="/cda:ClinicalDocument/cda:code/@displayName"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Clinical Document</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- CDA Document Title -->
    <xsl:variable name="cdaDocumentTitle">
        <xsl:choose>
            <xsl:when test="/cda:ClinicalDocument/cda:title and
                            string-length(/cda:ClinicalDocument/cda:title)  &gt;= 1">
                <xsl:value-of select="/cda:ClinicalDocument/cda:title"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$cdaDocumentType"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="BANNER_HEIGHT_PX" select="90 + (ceiling(string-length($cdaDocumentTitle) div 90) * 20)"/>
    
    <!-- CDA Document Creation Date Time -->
    <xsl:variable name="cdaDocumentCreationTime">
        <xsl:call-template name="show-time">
            <xsl:with-param name="datetime" select="/cda:ClinicalDocument/cda:effectiveTime"/>
        </xsl:call-template>
    </xsl:variable>
    
    <!-- CDA Document Creation Date  -->
    <xsl:variable name="cdaDocumentCreationDate">
        <xsl:call-template name="show-date">
            <xsl:with-param name="datetime" select="/cda:ClinicalDocument/cda:effectiveTime"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- CDA Document Creation Date for top of document -->
    <xsl:variable name="cdaDocumentCreationDateForTopOfDocument">
        <xsl:call-template name="show-date">
            <xsl:with-param name="datetime" select="/cda:ClinicalDocument/cda:effectiveTime"/>
        </xsl:call-template>
    </xsl:variable>
    
    <!-- Document Rendering View Title -->
    <xsl:variable name="documentRenderingViewTitle">
        <xsl:call-template name="trim">
            <xsl:with-param name="string">
                <xsl:choose>
                    <xsl:when test="string-length($patientMRN) &gt; 0 and string-length($patientIHI) &gt; 0">
                        <xsl:value-of select="concat($patientGivenName,' ', $patientFamilyName,
                                                     ' | DOB ',
                                                     $patientDateOfBirth,
                                                     ' | IHI ',
                                                     $patientIHI)"/>
                    </xsl:when>
                    <xsl:when test="$patientMRN='' and string-length($patientIHI) &gt; 0">
                        <xsl:value-of select="concat($patientGivenName,' ', $patientFamilyName,
                                                     ' | DOB ',
                                                     $patientDateOfBirth,
                                                     ' | IHI ',
                                                     $patientIHI)"/>
                    </xsl:when>
                    <xsl:when test="string-length($patientMRN) &gt; 0 and $patientIHI=''">
                        <xsl:value-of select="concat($patientGivenName,' ', $patientFamilyName,
                                                     ' | DOB ',
                                                     $patientDateOfBirth,
                                                     ' | IHI ',
                                                     $patientIHI)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($patientGivenName,' ', $patientFamilyName,
                                                     ' | DOB ',
                                                     $patientDateOfBirth,
                                                     ' | IHI ',
                                                     $patientIHI)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable> 
    
    <!-- Encounter -->
    <xsl:variable name="encounterStartDateTime">
        <xsl:if
            test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:low/@value!=''">
            <xsl:call-template name="show-time">
                <xsl:with-param name="datetime"
                    select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:low"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="encounterEndDateTime">
        <xsl:if
            test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value!=''">
            <xsl:call-template name="show-time">
                <xsl:with-param name="datetime"
                    select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="encounterDateTime">
        <xsl:if
            test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/@value!=''">
            <xsl:call-template name="show-time">
                <xsl:with-param name="datetime"
                    select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>

    <xsl:variable name="encounterStartDate">
        <xsl:if
            test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:low/@value!=''">
            <xsl:call-template name="show-date">
                <xsl:with-param name="datetime"
                    select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:low"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="encounterEndDate">
        <xsl:if
            test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high/@value!=''">
            <xsl:call-template name="show-date">
                <xsl:with-param name="datetime"
                    select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:high"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="encounterDate">
        <xsl:if
            test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/@value!=''">
            <xsl:call-template name="show-date">
                <xsl:with-param name="datetime"
                    select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="encounterDuration">
        <xsl:if test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:width/@value!='' and
                      /cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:width/@unit!=''">
            <xsl:call-template name="getDuration">
                <xsl:with-param name="value" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:width/@value"/>
                <xsl:with-param name="ucumUnitCode" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:effectiveTime/cda:width/@unit"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:variable>
    
    <!--================================================================================================================================================================================-->
    <!-- [END] GLOBAL VARIABLES -->
    
    <!-- For Path and DI - Delay Message (Modification by Accenture) -->
    
    <!-- [END] For Path and DI - Delay Message (Modification by Accenture) -->
    
    <!-- ENTRY TEMPLATE -->    



    <xsl:template match="/cda:ClinicalDocument">
        <xsl:element name="html"> 
		<xsl:attribute name="lang">en</xsl:attribute>
            <xsl:element name="head">

            <xsl:element name="style">
            <xsl:attribute name="type">text/css</xsl:attribute>
            <xsl:attribute name="media">all</xsl:attribute>
            <xsl:attribute name="data-move-to-head">this</xsl:attribute>
            <!-- CSS classes -->
            
            .nbspSpan {
                margin-left: 4px;
            }
            .mediaIOS_7 {
                height:600px;
                overflow-x: hidden;
                overflow-y: scroll;
                width: 100%;
                -webkit-overflow-scrolling: touch;
            }
            
            .mediaIOS {
                height:600px;
                /*overflow-x: hidden;*/
                overflow-y: scroll;
                width: 100%;
                /*-webkit-overflow-scrolling: touch;*/
            }
            
            .mediaIOS img {
                width:95%;
            }
                   
            .mediaPrint{
                display: none;
            }
            
            .pageWidth { 
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX"/>px;
                width: 100%;
            }

            .pageWidthWithLeftMargin { 
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX + $LEFT_MARGIN_WIDTH_PX"/>px;
                width: 100%;
            }
            
            .halfPageWidth { 
                width: <xsl:value-of select="$HALF_CONTENT_WIDTH_PX"/>px; 
            }
            .quarterPageWidth { 
                width: <xsl:value-of select="$QUARTER_CONTENT_WIDTH_PX"/>px; 
            }

            .sectionPageWidth {
                width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PCT"/>%;
            }
            
            .sectionPageWidthMinusMargin {
                width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PCT - 2"/>%;
            }
            
            .generictable {
                width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PCT"/>%;
                border-spacing: 0px; 
                padding: 0px;
                border-spacing: 0px;
                empty-cells: show;
                border: 1px SOLID #EEEEEE;
                table-layout: fixed;
                word-wrap: break-word;
                background-color: #DDDDDD;
            }

            .positionRelative{
                position: relative; 
                top: <xsl:value-of select="$BANNER_HEIGHT_PX"/>px;
            }

            .generictable--mod {
                border: 0;
            }

            .generictable--mod-padding {
                padding: 5px;
            }
            
            .genericul {
                margin-bottom: 15px;
            }

            .genericol {
                margin-bottom: 15px;
            }

            .documentTitleTable {
                border-spacing: 0;
                border-collapse: collapse;
                margin-bottom: 15px;
                margin-top: 12px;
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX"/>px;
                width: 100%;
            }

            .documentTitleTableAuthorDetailsTd {
                width: 60%;
                vertical-align: top;
            }

            .documentTitleTableLogoTd {
                width: 40%;
                vertical-align: top;
                text-align: right;
                padding: 0px;
            }

            .documentTitleAuthorDetailsTable {
                border-spacing: 0;
                border-collapse: collapse;
                padding: 0px;
                empty-cells: show;
                word-wrap: break-word;
                table-layout: fixed;
                width: 100%;
            }
            
            .documentTitleAuthorDetailsTableTh {
                padding-top: 0px;
                padding-bottom: 0px;
                padding-right: 0px;
                font-weight: bold;
                text-align: left;
                vertical-align: top;
                word-wrap: break-word; 
                width: 20%;
            }
            
            .documentTitleAuthorDetailsTableTd {
                padding-top: 0px;
                padding-bottom: 0px;
                padding-left: 5px;
                text-align: left;
                vertical-align: top;
                word-wrap: break-word; 
                width: 80%;
             }
            
            .generictr {
                vertical-align: top;
             }
             
             .generictd {
                background-color:#FFFFFF;
                border-top: 1px SOLID #EEEEEE;
                word-wrap: break-word;                                
             }
             
             .generictr .generictd a {
				color : #d82662;
				}

			 .generictr .generictd a:hover {
				text-decoration: underline;
			}
			
             .genericth {
                 padding-top: 1px;
                 padding-bottom: 1px;
                 background-color:#DDDDDD;
                 font-size: 11px;
                 font-weight: bold;
                 text-align: left;
                 word-wrap: break-word;                                 
             }
             
            ul {
                padding-top: 0px;
                margin-top: 0px;
                padding-bottom: 0px;
                margin-bottom: 0px;
            }

            ol {
                padding-top: 0px;
                margin-top: 0px;
                padding-bottom: 0px;
                margin-bottom: 0px;
            }

            .xFixed {
                font-family:monospace;
            }

            .underline {
                text-decoration: underline;
            }
            
            .nounderline {
                text-decoration: none;
            }
            
            .bold {
                font-weight: bold;
            }
            
            .emphasis {
                font-variant: small-caps;
            }
            
            .italic {
                font-style: italic;
            }
            
            .Lrule {
                border-left: 1px SOLID #000000;
            }
            
            .Rrule {
                border-right: 1px SOLID #000000;
            }
            
            .botrule {
                border-bottom: 1px SOLID #000000;
            }
            .toprule {
                border-top: 1px SOLID #000000;
            }
            
            .noLrule {
                border-left: 1px SOLID #EEEEEE;
            }
            
            .noRrule {
                border-right: 1px SOLID #EEEEEE;
            }
            
            .noBotrule {
                border-bottom: 1px SOLID #EEEEEE;
            }
            
            .noToprule {
                border-top: 1px SOLID #EEEEEE;
            }
            
            .paragraph {
                border-spacing: 0px; 
                padding: 0px;
                border-spacing: 0px;
                empty-cells: show;
                border: 0px SOLID #EEEEEE;                    
                word-wrap: break-word;
            }
            
            .horizontalspacer {
                height: 15px;
                border-style: none;
                border-width: 1px;
                border-color: #FFFFFF;
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX + $LEFT_MARGIN_WIDTH_PX"/>px;
                width: 100%;            
            }

            .hi {
                font-size: 9px;
            }

            .<xsl:value-of select="$PROVIDER_INDIVIDUAL_IDENTIFIER_CSS_CLASS"/> {
                font-size: 9px;
                margin-left: 20px;
            }
            
            .<xsl:value-of select="$PROVIDER_ORGANISATION_IDENTIFIER_CSS_CLASS"/> {
                font-size: 9px;
                margin-left: 20px;
            }
            
            .<xsl:value-of select="$PROVIDER_DEVICE_IDENTIFIER_CSS_CLASS"/> {
                font-size: 9px;
                margin-left: 20px;
            }

            .documentindicator {
                width: 100%;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX"/>px;
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                text-align: center;
                vertical-align: middle;
                font-weight: bold;
            }

            .documentindicatorcolours {
                background: #555;
                color: #FFFFFF;
            }

            .documentindicatorcolours-start{
                border: 0px SOLID #000000;
                margin-top: 0px;
                margin-bottom: 0px;
                padding-bottom: 0px;
                padding-top: 0px;
            }

            .documentindicatorcolours-administrative{
                border: 0px SOLID #000000;
                margin-top: 10px;
                margin-bottom: 10px;
                padding-bottom: 0px;
                padding-top: 0px;
            }

            .documentindicatorcolours-endofdocument{
                border: 0px SOLID #000000;
                margin-top: 0px;
                margin-bottom: 0px;
                padding-bottom: 0px;
                padding-top: 0px;
            }
            
            .addressdl {
                display: inline;
                margin: 0px;
                padding: 0px;
                text-align: left;
            }
            
            .addressdt {
                margin: 0px;
                padding: 0px;
                text-align: left;
                font-weight: bold;
            }
            
            .addressdd {
                display: inline;
                margin: 0px;
                padding: 0px;
                text-align: left;
            }

            .contactdetailsul {
                list-style-type: none;
                margin: 0px;
                padding: 0px;
                padding-left: 0;
                text-align: left;
            }
            
            .contactdetailsli {
                margin: 0px;
                padding: 0px;
                text-align: left;
            }
            
            .contactdetailsdl {
                display: inline;
                margin: 0px;
                padding: 0px;
                text-align: left;
            }
            
            .contactdetailsdt {
                margin: 0px;
                padding: 0px;
                text-align: left;
                font-weight: bold;
            }
            
            .contactdetailsdd {
                display: inline;
                margin: 0px;
                padding: 0px;
                text-align: left;
            }
            
            .specialtiesul {
                list-style-type: none;
                margin: 0px;
                padding: 0px;
                padding-left: 0;
                text-align: left;
            }
            
            .specialtiesli {
                margin: 0px;
                padding: 0px;
                text-align: left;
            }

            .BANNER {
                top: 100px;
                background-color: #000000;
                color: #FFFFFF;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX"/>px;
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                width: 100%;
                z-index: 10000;
                position: fixed;
                word-wrap: break-word;
                height: <xsl:value-of select="$BANNER_HEIGHT_PX"/>px;
                _position:absolute;
                _top:expression(0+((e=document.documentElement.scrollTop)?e:document.body.scrollTop)+'px');
            }

            .BANNER_BACK {
                top: 0px;
                background-color: #000000;
                color: #FFFFFF;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX"/>px;
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                width: 100%;
                z-index: 10000;
                word-wrap: break-word;
                height: <xsl:value-of select="$BANNER_HEIGHT_PX"/>px;
                margin:0 auto;
            }
            
            .clearfix:after {content: "."; display: block; height: 0; clear: both; visibility: hidden;}
            .clearfix {display: inline-block;}
            /* Hides from IE-mac \*/
            * html .clearfix {height: 1%;}
            .clearfix {display: block;}
            /* End hide from IE-mac */
            
            .BANNER_DOCUMENT_TITLE_DIV {
                padding-top: 15px;
                vertical-align: top;
                text-align: center;
                margin 0px;
                font-size: 18px;
                font-family: Helvetica;
                color: #FFFFFF;
                font-weight: bold;
                word-wrap: break-word;
                background-color: #000000;
            }

            .BANNER_DOCUMENT_DATE_DIV {
                vertical-align: top;
                text-align: center;
                margin 0px;
                font-size: 14px;
                font-family: Helvetica;
                color: #FFFFFF;
                background-color: #000000;
                font-weight: bold;
            }
            
            .BANNER_PATIENT_DETAILS_DIV {
                padding-left: 15px;
                padding-right: 15px;
                vertical-align: top;
                text-align: left;
                overflow: auto;
                background-color: #000000;
                height: 58px;
            }

            .banner_patient_name{
                display: inline; 
                margin-right: 20px; 
                font-size: 14px;
            }
            
            .bannerDl {
                width: 100%;
                display: inline;
            }
            
            .bannerDt {
                display: inline;
                font-size: 14px;
                color: #CCCCCC;
            }
            
            .bannerDd {
                margin-left: 0px;
                display: inline;
                font-size: 14px;
                margin-right: 30px;
            }
            
            .authorOrganisationClass {
                font-size: 26px;
                font-family: Helvetica;
                color: #000000;
            }

            .spacedSection {  
                margin-bottom: 0px;
                margin-top: 0px;
            }
            
            .detailsHalfTableHeaderDiv {
                font-style: italic;
                color: #000000;
                font-weight: bold;
                margin-bottom: 3px;
                width: 100%;
                word-wrap: break-word;
            }

            .detailsHalfTableHeaderDiv-mod {
                font-style: italic;
                color: #000000;
                font-weight: bold;
                margin-bottom: 3px;
                word-wrap: break-word;
                background-color: #f1f1f1;
            }

            .detailsHalfTable {
                table-layout: fixed;
                width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PCT"/>%;
                spacing: 0px;
                padding: 0px;
                borer: 0px;
                margin-bottom: 15px;
            }
            
            .detailsHalfTableTh {
                width: <xsl:value-of select="$DETAILS_HALF_TABLE_TH_WIDTH_PCT"/>%;
                word-wrap: break-word;
                vertical-align: top;
                text-align: left;
            }

            .detailsHalfTableThSpan {
                word-wrap: break-word;
                font-style: normal;
                color: #645F6E;
            }
            
            .detailsHalfTableTd {
                width: <xsl:value-of select="$DETAILS_HALF_TABLE_TD_WIDTH_PCT"/>%;
                word-wrap: break-word;
                vertical-align: top;
                word-wrap: break-word;
            }

            .identifier {
                margin-left: 20px; 
                font-size: 9px;
            }
            
            .detailsTable {
                border-spacing: 0;
                border-collapse: collapse;
                table-layout: fixed;
                margin-left: 0px;
                margin-top: 0px;
                margin-bottom: 0px;
                border-top: 0px;
                border-bottom: 1px SOLID #000000;
                width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PCT"/>%;
            }

            .detailsTable--mod {
                padding: 15px;
            }
            
            .detailsTableTr {
                vertical-align: top;
            }
            
            .detailsTableTd {
                background-color:#F1F1F1;
                width: <xsl:value-of select="$HALF_CONTENT_WIDTH_PCT"/>%;
            }
            
            .detailsTableTh {
                background-color:#F1F1F1;
                text-align: left;
            }
            
            .sectionHeader {
                width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PCT"/>%;
                font-size: 17px;
                font-weight: bold;
                color: #000000;
                margin-bottom: 5px;
                margin-top: 0px;
                border-bottom: 1px SOLID #000000;;
                padding: 0px;
                word-wrap: break-word;
            }
            
            .nestedSectionHeader {
                width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PCT - 2"/>%;
                font-size: 17px;
                font-weight: bold;
                color: #000000;
                margin-bottom: 5px;
                border-bottom: 1px SOLID #000000;;
                word-wrap: break-word;
            }
            
            .participantsHeader {
                font-size: 17px;
                font-weight: bold;
                color: #000000;
                margin-bottom: 5px;
                margin-top: 0px;
                border-bottom: 1px SOLID #000000;
                padding: 0px;
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX - ($LEFT_MARGIN_WIDTH_PX + $RIGHT_MARGIN_WIDTH_PX)"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX - ($LEFT_MARGIN_WIDTH_PX + $RIGHT_MARGIN_WIDTH_PX)"/>px;
                margin-left: <xsl:value-of select="$LEFT_MARGIN_WIDTH_PX"/>px;
                margin-right: <xsl:value-of select="$RIGHT_MARGIN_WIDTH_PX"/>px
            }
                        
            .listTableCaption {
                font-style: italic;


                color: #645F6E;
                font-weight: bold;
                font-size: 12px;
                padding: 5px 5px 5px 0px;
                text-align: left;
            }
            
            .participantsTableClass {
                padding: 0px;
                border-spacing: 0px;
                border-collapse: collapse;
                table-layout: fixed;
                word-wrap: break-word;
                margin-bottom: 15px;
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX - ($LEFT_MARGIN_WIDTH_PX + $RIGHT_MARGIN_WIDTH_PX)"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX - ($LEFT_MARGIN_WIDTH_PX + $RIGHT_MARGIN_WIDTH_PX)"/>px;
                margin-left: <xsl:value-of select="$LEFT_MARGIN_WIDTH_PX"/>px;
                margin-right: <xsl:value-of select="$RIGHT_MARGIN_WIDTH_PX"/>px
            }

            .participantsTableClass-mod {
                table-layout: fixed;
                word-wrap: break-word;
            }
            
            .PARTICIPANT_HEADER_ROW_TH {
                padding-top: 1px;
                padding-bottom: 1px;
                background-color:#DDDDDD;
                font-size: 11px;
                font-weight: bold;
                padding-left: 15px;
                padding-right: 15px;
                text-align: left;
                word-wrap: break-word;                                
            }
            
            .PARTICIPANT_BODY_ROW_TD {
                border-top: 1px SOLID #EEEEEE;
                padding: 5px 15px 5px 15px;
                vertical-align: top;
                word-wrap: break-word;
            }

            .RECIPIENT_HEADER_ROW_TH {
                padding-top: 1px;
                padding-bottom: 1px;
                background-color:#DDDDDD;
                font-size: 11px;
                font-weight: bold;
                padding-left: 15px;
                padding-right: 15px;
                text-align: left;
                word-wrap: break-word;                                
            }
            
            .RECIPIENT_HEADER_ROW_TD {
                border-top: 1px SOLID #EEEEEE;
                padding: 5px 15px 5px 15px;
                vertical-align: top;
                word-wrap: break-word;
            }
            
         
            
            pre {
                word-wrap: break-word;
                white-space: pre-wrap;
                margin:0px;
            }
            
            p.div {
                width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX"/>px;
            }
            
            a.ageLink {
                text-decoration: none;
            }
            
            a.ageLink:link { 
            color: #FFFFFF;
            }
            
            a.ageLink:visited { 
            color: #FFFFFF;
            }
            
            a#ageLink:hover {
            color: #FFFFFF;
            }
            
            a#ageLink:active {
            color: #FFFFFF;
            }

            .sr-only-pdf{
            position: absolute;
            width: 1px;
            height: 1px;
            margin: -1px;
            padding: 0;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            border: 0;
            }
                                  
            <!-- PDF frame overlap with banner (modification by Accenture) -->

            div#LOGO {
                width: 400px;
                height: 100px;
                clip: rect(0px, 400px, 100px, 0px);
                overflow: hidden;
                padding: 0px;
            }
            #iframeOverlapPDF{
                position: absolute;
                top: 100px;
                left: 0;
                height: 100%;
                width: 100%;
                z-index: -1;
                border: none;
                background-color:transparent;
            }
			
            <!-- Fix the Accessibility color contrast -->
            .preview .detailsHalfTableThSpan{
 		        color: #645F6E;
	        }
            <!-- [END] PDF frame overlap with banner (modification by Accenture) -->

        </xsl:element> <!--  </style text="text/css" media="all"> -->
        <xsl:element name="style">
            <xsl:attribute name="type">text/css</xsl:attribute>
            <xsl:attribute name="media">screen</xsl:attribute>
            <xsl:attribute name="data-move-to-head">this</xsl:attribute>
            <!-- CSS classes -->
             .spaceToScrollToFootnotesDiv { 
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX - ($RIGHT_MARGIN_WIDTH_PX + $LEFT_MARGIN_WIDTH_PX)"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX - ($RIGHT_MARGIN_WIDTH_PX + $LEFT_MARGIN_WIDTH_PX)"/>px;
                width: 100%
            }
            
            .DETAILS {
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX - ($RIGHT_MARGIN_WIDTH_PX + $LEFT_MARGIN_WIDTH_PX)"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX - ($RIGHT_MARGIN_WIDTH_PX + $LEFT_MARGIN_WIDTH_PX)"/>px;
                width: 100%
                margin: 0px;                      
                bottom: 0px; 
                background: #FFFFFF;
                padding: 0px 0px 0px 0px;
                margin-left: <xsl:value-of select="$LEFT_MARGIN_WIDTH_PX"/>px;
                margin-right: <xsl:value-of select="$RIGHT_MARGIN_WIDTH_PX"/>px;
            }

            <!-- Elements with id attributes -->
            div#ROOT {
                position:absolute;
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                max-width: <xsl:value-of select="$FULL_VIEWPORT_WIDTH_PX"/>px;
            }
            
            .CONTENT {
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
                max-width: <xsl:value-of select="$FULL_CONTENT_WIDTH_PX"/>px;
                width: 100%;
                margin:0 auto;                    
                bottom: 0px; 
                background: #FFFFFF;
            }
			.document-view{
			height: 90% !important;
			}
            .BODY {
                min-width: <xsl:value-of select="$MINIMUM_CONTENT_WIDTH_PX"/>px;
              <!--  max-width: <xsl:value-of select="$FULL_VIEWPORT_WIDTH_PX - ($LEFT_MARGIN_WIDTH_PX + $RIGHT_MARGIN_WIDTH_PX)"/>px; -->
                width: 100%
                margin: 0px;                      
                bottom: 0px; 
                background: #FFFFFF;
                padding: 0px 0px 0px 0px;
                margin-left: <xsl:value-of select="$LEFT_MARGIN_WIDTH_PX"/>px;
                margin-right: <xsl:value-of select="$RIGHT_MARGIN_WIDTH_PX"/>px;
                text-align:left;
            }
        </xsl:element> <!--  </style text="text/css" media="screen"> -->
        
        <xsl:element name="style">
            <xsl:attribute name="type">text/css</xsl:attribute>
            <xsl:attribute name="media">print</xsl:attribute>
            <xsl:attribute name="data-move-to-head">this</xsl:attribute>
            .BANNER {
            display: none;
            }
            
                        
            <!-- CSS classes -->
            .showHideHeaderDetailsButtonTableRow { 
                display: none;
            }
            
            .spaceToScrollToFootnotesDiv { 
                display: none;
            }


            .media { 
                display: none;
            }
            
            .mediaPrint {
                display: inline;
            }
            
           .mediaPrint img {
                width:80%;
            }
            
            .mediaIOS{
                width: 100%;
                height: 100%;
                overflow: hidden;
            }
            
            
           .mediaIOS img {
                width:80%;
            }
        </xsl:element> <!--  </style text="text/css" media="print"> -->
			<!--xsl:element name="script">
			    <xsl:attribute name="src">https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js</xsl:attribute>
			</xsl:element>
						<xsl:element name="script">
			    <xsl:attribute name="src">https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js</xsl:attribute>
			</xsl:element>
			<xsl:element name="link">
			    <xsl:attribute name="href">https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css</xsl:attribute>
				<xsl:attribute name="rel">stylesheet</xsl:attribute>
			</xsl:element-->	            
                <xsl:element name="div">
                    <xsl:attribute name="id">CDB_Medicare</xsl:attribute>
                    <xsl:attribute name="class">hidden</xsl:attribute>
                    <xsl:value-of select="$CDB_08_MEDICARE_A" />
                </xsl:element>
               
             </xsl:element>
       <xsl:element name="body">
         
                <xsl:comment><xsl:value-of select="$DO_NOT_EDIT_NOTE"/></xsl:comment>
                <xsl:comment><xsl:value-of select="$VERSION_NOTE"/></xsl:comment>
                <xsl:element name="title"><xsl:value-of select="$documentRenderingViewTitle"/></xsl:element>
                <xsl:call-template name="addJavascript"/>
          
            
				
                <!-- Display the Banner -->
                <!--  <xsl:element name="div">
                    <xsl:attribute name="class">BANNER clearfix</xsl:attribute>
                   Modification by Accenture
                    <iframe id="iframeOverlapPDF" src="about:blank"></iframe>
                   [END] Modification by Accenture
                    <xsl:call-template name="getBanner"/>
                </xsl:element> -->   
				
				<xsl:element name="div">
                    <xsl:attribute name="class">section section--darker-grey</xsl:attribute>
                    
                    <xsl:element name="div">
                    
                     <xsl:element name="div">
                    	<xsl:attribute name="class">BANNER_BACK clearfix js-affix</xsl:attribute>
                    	<xsl:call-template name="getBanner"/>
                	</xsl:element>
                            
                <xsl:element name="div">
                    <xsl:attribute name="class">CONTENT</xsl:attribute>
                    <!-- Display Start of Document Indicator -->
                    <xsl:call-template name="getStartOfDocumentIndicator"/>
                    
                    <!-- Display Rendering Specification incompatibility warning if necessary -->
                    <xsl:if test="$isStylesheetCompatibleWithRequiredRenderingSpecificationVersion='false'">
                        <xsl:call-template name="getRenderingSpecificationIncompatibilityWarning"/>
                    </xsl:if>
                    
                    <!-- Display Document Title -->
                    <xsl:element name="div">
                        <xsl:attribute name="class">DETAILS</xsl:attribute>
                        <xsl:call-template name="getAuthorDetailsAndLogoTable"/>
                    </xsl:element>
                    
                    <!-- For Path and DI (Modification by Accenture) -->
                    <xsl:if test="$cdaDocumentType='Pathology Report' or $cdaDocumentType='Diagnostic Imaging Report' or $cdaDocumentType='Advance Care Information'">
                        <xsl:if test="string-length(//cda:externalDocument/cda:text/cda:reference/@value) &gt; 0">
                            <xsl:call-template name="processPathorDIAttachment">
                                <xsl:with-param name="element" select="//cda:externalDocument"/>
                                <xsl:with-param name="externalDocumentAttachment">yes</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:if>
                    <!-- [END] For Path and DI (Modification by Accenture) -->
                    
                    <!-- For PCML (Modification by Accenture) -->
                    <xsl:if test="$cdaDocumentType='Pharmacist Shared Medicines List'">
                        <xsl:if test="string-length(//cda:observationMedia/cda:value/cda:reference/@value) &gt; 0">
                            <xsl:call-template name="processPathorDIAttachment">
                                <xsl:with-param name="element" select="//cda:observationMedia"/>
                                <xsl:with-param name="externalDocumentAttachment">no</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:if>
                    <!-- [END] For PCML (Modification by Accenture) -->
            
                    <!-- Display the Body -->
                    <xsl:element name="div">
                        <xsl:attribute name="class">BODY</xsl:attribute>

                        <xsl:element name="div">
                            <xsl:attribute name="id">inlinePdfDiv</xsl:attribute>
                            <xsl:attribute name="class">media</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="div">
                                <xsl:attribute name="id">noPDFReader</xsl:attribute>
                            </xsl:element>
                        <xsl:element name="div">
                            <xsl:attribute name="id">printPdfDiv</xsl:attribute>
                        </xsl:element>

                        <xsl:choose>
                            <xsl:when test="cda:component/cda:nonXMLBody">
                                <xsl:apply-templates select="cda:component/cda:nonXMLBody"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="processStructuredBody">
                                    <xsl:with-param name="structuredBody" select="cda:component/cda:structuredBody"/>
                                    <xsl:with-param name="processAdministrativeObservations">no</xsl:with-param>
                                </xsl:call-template>
                                <xsl:if test="cda:component/cda:structuredBody/cda:component/cda:section[(cda:code/@code='102.16080') and (cda:code/@codeSystem='1.2.36.1.2001.1001.101')] and
                                              $administrativeObservationsSectionDisplay='true'">
                                    <xsl:call-template name="processStructuredBody">
                                        <xsl:with-param name="structuredBody" select="cda:component/cda:structuredBody"/>
                                        <xsl:with-param name="processAdministrativeObservations">yes</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>

                    <!-- Display Administrative Details Indicator -->
                    <xsl:call-template name="getAdministrativeDetailsIndicator"/>

                    <xsl:element name="div">
                        <xsl:attribute name="class">DETAILS</xsl:attribute>

                        <!-- Display Encounter Details and Facility Table -->
                        <xsl:choose>
                            <xsl:when test="$cdaDocumentType='e-Discharge Summary'">
                                <xsl:call-template name="getEncounterDetailsAndFacilityTable"/>    
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>

                        <!-- Display Patient Details and Document Details -->
                        <xsl:call-template name="getPatientDetailsAndDocumentDetailsTable"/>
                        <xsl:call-template name="getHorizontalSpacer"/>
                    </xsl:element>
                    
                    <!-- Display Participants -->
                    <xsl:if test="count(./cda:participant[(@typeCode='PART' or @typeCode='IRCP') and cda:associatedEntity/cda:associatedPerson]) &gt; 0">
                        <xsl:call-template name="getParticipantsTable">
                            <xsl:with-param name="title">PARTICIPANTS</xsl:with-param>
                            <xsl:with-param name="tableId">PARTICIPANTS_TABLE</xsl:with-param>
                            <xsl:with-param name="participants" select="./cda:participant[(@typeCode='PART' or @typeCode='IRCP') and cda:associatedEntity/cda:associatedPerson]" />
                        </xsl:call-template>
                    </xsl:if>
                
                    <xsl:if test="count(./cda:informationRecipient[@typeCode='PRCP' or not(@typeCode)]/cda:intendedRecipient) &gt; 0">
                        <xsl:call-template name="getRecipientsTable">
                            <xsl:with-param name="title">Primary Recipients</xsl:with-param>
                            <xsl:with-param name="tableId">PRIMARY_RECIPIENTS_TABLE</xsl:with-param>
                            <xsl:with-param name="recipients" select="./cda:informationRecipient[@typeCode='PRCP' or not(@typeCode)]/cda:intendedRecipient" />
                        </xsl:call-template>
                    </xsl:if>
                    
                    <xsl:if test="count(./cda:informationRecipient[@typeCode='TRC']/cda:intendedRecipient) &gt; 0">
                        <xsl:call-template name="getRecipientsTable">
                            <xsl:with-param name="title">Secondary Recipients</xsl:with-param>
                            <xsl:with-param name="tableId">SECONDARY_RECIPIENTS_TABLE</xsl:with-param>
                            <xsl:with-param name="recipients" select="./cda:informationRecipient[@typeCode='TRC']/cda:intendedRecipient" />
                        </xsl:call-template>
                    </xsl:if>
                    
                    <!-- Display footnotes -->
                    <xsl:element name="div">
                        <xsl:call-template name="getFootnotesTable"/>
                    </xsl:element>

                    <!-- Display End of Document -->
                    <xsl:if test="$styleSheetVersionDisplay='true'">
                         <xsl:call-template name="getStyleSheetVersionIndicator"/>
                    </xsl:if>
                    <xsl:call-template name="getEndOfDocumentIndicator"/>

                    <!-- Space to allow scrolling to footnote references -->
                    <xsl:call-template name="getSpaceToScrollToFootnotesDiv"/>
                </xsl:element> <!-- </div> -->
                </xsl:element> <!--clinicaldocument div  -->
           </xsl:element>
		   </xsl:element>
        </xsl:element> <!-- </html -->
    </xsl:template>
    <!--================================================================================================================================================================================-->
    <!-- [END] ENTRY TEMPLATE -->
    
    
    
    
    <!-- BANNER TEMPLATES -->
    <!--================================================================================================================================================================================-->   

    <xsl:template name="getBanner">
        <xsl:variable name="completionCode">
            <xsl:if test="/cda:ClinicalDocument/ext:completionCode and
                /cda:ClinicalDocument/ext:completionCode/@codeSystem and
                /cda:ClinicalDocument/ext:completionCode/@codeSystem='1.2.36.1.2001.1001.101.104.20104' and
                /cda:ClinicalDocument/ext:completionCode/@code and
                string-length(/cda:ClinicalDocument/ext:completionCode/@code) &gt; 0">
                <xsl:choose>
                    <xsl:when test="/cda:ClinicalDocument/ext:completionCode/@code='F'">Final</xsl:when>
                    <xsl:when test="/cda:ClinicalDocument/ext:completionCode/@code='I'">Interim</xsl:when>
                    <xsl:when test="/cda:ClinicalDocument/ext:completionCode/@code='W'">Withdrawn</xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        
        <xsl:element name="div">
            <xsl:attribute name="class">BANNER_DOCUMENT_TITLE_DIV</xsl:attribute>
            <xsl:choose>
                <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PCEHR_DISPENSE_RECORD_CDA_IMPLEMENTATION_GUIDE_OID]">
                    <xsl:text>eHealth Dispense Record</xsl:text>
                </xsl:when>
                
                <xsl:when test="/cda:ClinicalDocument/cda:templateId[@root=$NEHTA_PCEHR_PRESCRIPTION_RECORD_CDA_IMPLEMENTATION_GUIDE_OID]">
                    <xsl:text>eHealth Prescription Record</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$cdaDocumentTitle"/><xsl:if test="$completionCode = 'Withdrawn'"><xsl:value-of select="concat(' - ', 'WITHDRAWN')"/></xsl:if>  
                </xsl:otherwise>
            </xsl:choose>                                  
        </xsl:element> 
 <!-- </div> -->

            <xsl:element name="div">
                <xsl:attribute name="class">BANNER_DOCUMENT_DATE_DIV</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$cdaDocumentType='e-Discharge Summary' and (string-length($encounterEndDate) &gt; 0)"><xsl:value-of select="$encounterEndDate"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$cdaDocumentCreationDate"/></xsl:otherwise>
                    </xsl:choose>
            </xsl:element> <!-- </div> -->

            <xsl:element name="div">
                <xsl:attribute name="class">BANNER_PATIENT_DETAILS_DIV</xsl:attribute>
                <xsl:element name="div">
                    <xsl:attribute name="class">banner_patient_name</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$patientFamilyName!='' and string-length($patientFamilyName) &gt; 0">
                            <xsl:if test="$patientPrefix!='' and string-length($patientPrefix) &gt; 0">
                                <xsl:value-of select="$patientPrefix"/><xsl:text> </xsl:text>
                            </xsl:if>
                            <xsl:if test="$patientGivenName!='' and string-length($patientGivenName) &gt; 0">
                                <xsl:value-of select="$patientGivenName"/><xsl:text> </xsl:text>
                            </xsl:if>                            
                            <xsl:element name="span">
                                <xsl:attribute name="class">bold</xsl:attribute>
                                <xsl:value-of select="$patientFamilyName"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="b">
                                <xsl:value-of select="$patientName"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>  <!-- </div> -->
                
                <xsl:element name="dl">
                    <xsl:attribute name="class">bannerDl</xsl:attribute>
                    <xsl:element name="dt">
                        <xsl:attribute name="class">bannerDt</xsl:attribute>
                        DoB
                    </xsl:element>
                    <xsl:element name="dd">
                        <xsl:attribute name="class">bannerDd</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="not($patientAge='DECEASED') and not($patientAge='AGE UNKNOWN') and string-length($patientCodedAge) = 0">
                                <xsl:value-of select="$patientDateOfBirth"/><xsl:value-of select="concat(' (', $patientAge)"/>
                                <xsl:call-template name="getCalculatedAgeLink"/>
                                <xsl:text>)</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$patientDateOfBirth"/><xsl:value-of select="concat(' (', $patientAge, ')')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="dt">
                        <xsl:attribute name="class">bannerDt</xsl:attribute>
                        SEX
                    </xsl:element>
                    <xsl:element name="dd">
                        <xsl:attribute name="class">bannerDd</xsl:attribute>
                        <xsl:value-of select="$patientSex"/>
                    </xsl:element>
                    
                    <xsl:if test="$patientIHI!=''">
                        <xsl:element name="dt">
                            <xsl:attribute name="class">bannerDt</xsl:attribute>
                            Individual Healthcare Identifier (IHI)
                        </xsl:element>
                        <xsl:element name="dd">
                            <xsl:attribute name="class">bannerDd</xsl:attribute>
                            <xsl:value-of select="$patientIHI"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="string-length($patientMRN) &gt; 0">
                        <xsl:element name="dt">
                            <xsl:attribute name="class">bannerDt</xsl:attribute>
                            MRN
                        </xsl:element>
                        <xsl:element name="dd">
                            <xsl:attribute name="class">bannerDd</xsl:attribute>
                            <xsl:value-of select="$patientMRN"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:element> <!-- </dl> -->            
    </xsl:template>
    
    <xsl:template name="getCalculatedAgeLink">
        <xsl:element name="a">
            <xsl:attribute name="class">ageLink</xsl:attribute>
            <xsl:attribute name="href">#calculatedAgeAnchor</xsl:attribute>
            <xsl:text>*</xsl:text>
        </xsl:element>
    </xsl:template>
    
    <!--================================================================================================================================================================================-->   
    <!-- [END] BANNER TEMPLATES -->
    

    <!-- 1.2 TEMPLATES -->
    <!--================================================================================================================================================================================-->   

    <xsl:template name="getAuthorDetailsAndLogoTable">
        <xsl:variable name="authorOrganisation">
            <xsl:choose>
                <xsl:when test="string-length(/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name) &gt; 0">
                    <xsl:value-of select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name"/>
                </xsl:when>
                <xsl:when test="string-length(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name) &gt; 0">
                    <xsl:value-of select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name"/>
                </xsl:when>
                <xsl:when test="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedAuthoringDevice">
                    <xsl:value-of select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedAuthoringDevice/cda:softwareName/text()"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="authorName">
            <xsl:call-template name="show-name"><xsl:with-param name="name" select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor[1]/cda:assignedPerson/cda:name[1]"/></xsl:call-template>        
        </xsl:variable>
        <xsl:variable name="authorRole" select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor[1]/cda:code/@displayName"/>
        <xsl:variable name="authorPhoneNumber" select="substring-after(/cda:ClinicalDocument/cda:author/cda:assignedAuthor[1]/cda:telecom[starts-with(@value, 'tel')]/@value, 'tel:')"/>
        <xsl:variable name="facilityName" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name"/>
        <xsl:variable name="facilityDepartment" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:name"/>
        
        <xsl:if test="string-length($authorOrganisation) &gt; 0 or
                      string-length($authorName) &gt; 0 or
                      (/cda:ClinicalDocument/cda:component/cda:structuredBody//cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/png' or @mediaType='image/gif' or @mediaType='image/jpeg'])">
                <xsl:if test="(not($cdaDocumentType = 'Advance Care Information'))">
                <xsl:element name="table">                
                <xsl:attribute name="class">documentTitleTable generictable--mod</xsl:attribute>
                <xsl:element name="caption">
                    <xsl:attribute name="class">sr-only-pdf</xsl:attribute>
                    Administrative details for author
                </xsl:element>
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:attribute name="class">documentTitleTableAuthorDetailsTd</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:attribute name="class">authorOrganisationClass</xsl:attribute>
                            <xsl:value-of select="$authorOrganisation"/>
                        </xsl:element> <!-- </div> -->
                        <xsl:if test="string-length($authorName) &gt; 0">
                            <xsl:element name="div">
                                <xsl:element name="table">
                                    <xsl:attribute name="summary">DOCUMENT_AUTHOR_AND_LOGO_TABLE</xsl:attribute>                                   
                                    <xsl:attribute name="class">documentTitleAuthorDetailsTable</xsl:attribute>
                                    <xsl:element name="caption">
                                        <xsl:attribute name="class">sr-only-pdf</xsl:attribute>
                                        Document Author
                                    </xsl:element>
                                    <xsl:element name="tbody">
                                        <xsl:if test="string-length($authorName) &gt; 0">
                                                <xsl:element name="tr">
                                                <xsl:element name="th">
                                                    <xsl:attribute name="class">documentTitleAuthorDetailsTableTh</xsl:attribute>
                                                    <xsl:choose>
                                                        <xsl:when test="$cdaDocumentType = 'PCEHR Prescription Record'">Prescriber</xsl:when>
                                                        <xsl:when test="$cdaDocumentType = 'PCEHR Dispense Record'">Dispenser</xsl:when>
                                                        <xsl:otherwise>Author</xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:element>
                                                <xsl:element name="td">
                                                    <xsl:attribute name="class">documentTitleAuthorDetailsTableTd</xsl:attribute>
                                                    <xsl:value-of select="$authorName"/><xsl:if test="string-length($authorRole) &gt; 0"> (<xsl:value-of select="$authorRole"/>)</xsl:if>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="string-length($authorPhoneNumber) &gt; 0 and (/cda:ClinicalDocument/cda:author/cda:assignedAuthor[1]/cda:telecom[starts-with(@value, 'tel:')]/@use = 'WP')">
                                            <xsl:element name="tr">
                                                <xsl:element name="th">
                                                    <xsl:attribute name="class">documentTitleAuthorDetailsTableTh</xsl:attribute>
                                                    Phone
                                                </xsl:element>
                                                <xsl:element name="td">
                                                    <xsl:attribute name="class">documentTitleAuthorDetailsTableTd</xsl:attribute>
                                                    <xsl:value-of select="$authorPhoneNumber"/>
                                                </xsl:element>
                                            </xsl:element> <!-- </tr> -->
                                        </xsl:if>
                                        <xsl:choose>
                                            <xsl:when test="$cdaDocumentType = 'Event Summary'">
                                                <xsl:choose>
                                                    <xsl:when test="string-length($encounterDate) &gt; 0">
                                                        <xsl:element name="tr">
                                                            <xsl:element name="th">
                                                                <xsl:attribute name="class">documentTitleAuthorDetailsTableTh</xsl:attribute>
                                                                Encounter Period
                                                            </xsl:element>
                                                            <xsl:element name="td">
                                                                <xsl:attribute name="class">documentTitleAuthorDetailsTableTd</xsl:attribute>
                                                                <xsl:value-of select="$encounterDate"/>
                                                            </xsl:element>
                                                        </xsl:element> <!-- </tr> -->
                                                    </xsl:when>
                                                    <xsl:when test="(string-length($encounterStartDate) &gt; 0) and (string-length($encounterEndDate) &gt; 0)">
                                                        <xsl:element name="tr">
                                                            <xsl:element name="th">
                                                                <xsl:attribute name="class">documentTitleAuthorDetailsTableTh</xsl:attribute>
                                                                Encounter Period
                                                            </xsl:element>
                                                            <xsl:element name="td">
                                                                <xsl:attribute name="class">documentTitleAuthorDetailsTableTd</xsl:attribute>
                                                                <xsl:value-of select="concat($encounterStartDateTime, ' to ', $encounterEndDateTime)"/>
                                                            </xsl:element>
                                                        </xsl:element> <!-- </tr> -->
                                                    </xsl:when>
                                                    <xsl:when test="string-length($encounterDuration) &gt; 0">
                                                        <xsl:element name="tr">
                                                            <xsl:element name="th">
                                                                <xsl:attribute name="class">documentTitleAuthorDetailsTableTh</xsl:attribute>
                                                                Encounter Period
                                                            </xsl:element>
                                                            <xsl:element name="td">
                                                                <xsl:attribute name="class">documentTitleAuthorDetailsTableTd</xsl:attribute>
                                                                <xsl:value-of select="$encounterDuration"/>
                                                            </xsl:element>
                                                        </xsl:element> <!-- </tr> -->
                                                    </xsl:when>
                                                    <xsl:otherwise/>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:when test="$cdaDocumentType = 'e-Discharge Summary'">
                                                <xsl:if test="string-length($separationMode) &gt; 0">
                                                    <xsl:element name="tr">
                                                        <xsl:element name="th">
                                                            <xsl:attribute name="class">documentTitleAuthorDetailsTableTh</xsl:attribute>
                                                            Discharge To
                                                        </xsl:element>
                                                        <xsl:element name="td">
                                                            <xsl:attribute name="class">documentTitleAuthorDetailsTableTd</xsl:attribute>
                                                            <xsl:value-of select="$separationMode"/>
                                                        </xsl:element>
                                                    </xsl:element> <!-- </tr> -->
                                                </xsl:if>
                                                <xsl:if test="string-length($dischargeLocation) &gt; 0">
                                                    <xsl:element name="tr">
                                                        <xsl:element name="th">
                                                            <xsl:attribute name="class">documentTitleAuthorDetailsTableTh</xsl:attribute>
                                                            Discharge From
                                                        </xsl:element>
                                                        <xsl:element name="td">
                                                            <xsl:attribute name="class">documentTitleAuthorDetailsTableTd</xsl:attribute>
                                                            <xsl:value-of select="$dischargeLocation"/>
                                                        </xsl:element>
                                                    </xsl:element> <!-- </tr> -->
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise/>
                                        </xsl:choose>
                                    </xsl:element> <!-- </tbody> -->
                                </xsl:element> <!-- </table> -->
                            </xsl:element> <!-- </div> -->
                        </xsl:if>
                    </xsl:element> <!-- </td> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">documentTitleTableLogoTd</xsl:attribute>
                        <xsl:attribute name="align">right</xsl:attribute>
                        <xsl:if test="/cda:ClinicalDocument/cda:component/cda:structuredBody//cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/png' or @mediaType='image/gif' or @mediaType='image/jpeg']">
                            <xsl:call-template name="renderLogo"/>
                        </xsl:if>
                    </xsl:element> <!-- </td> -->                   
                </xsl:element> <!-- </tr> -->
            </xsl:element>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getEncounterDetailsAndFacilityTable">
        <xsl:element name="div">
            <xsl:attribute name="class">spacedSection pageWidthWithLeftMargin</xsl:attribute>
            <xsl:element name="table">
                <xsl:attribute name="class">detailsTable detailsTable--mod</xsl:attribute>
                <xsl:element name="caption">
                    <xsl:attribute name="class">sr-only-pdf</xsl:attribute>Encounter details and facility
                </xsl:element>
                <xsl:element name="tr">
                    <xsl:attribute name="class">detailsTableTr</xsl:attribute>
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsTableTd</xsl:attribute>
                        <xsl:call-template name="getEncounterDetails"/>
                        <xsl:call-template name="getResponsibleHealthProfessionalAtTimeOfDischargeRow"/>
                    </xsl:element> <!-- </td> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsTableTd</xsl:attribute>
                        <xsl:call-template name="getFacilityDetails"/>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->
            </xsl:element> <!-- </table> -->
        </xsl:element> <!-- </div> -->
    </xsl:template>
    
    <xsl:template name="getEncounterDetails">
        <xsl:if test="$encounterStartDateTime != '' or
            $encounterEndDateTime != '' or
            $encounterDateTime != '' or
            $separationMode != '' or
            $dischargeLocation">
            <xsl:element name="div">
                <xsl:attribute name="class">detailsHalfTableHeaderDiv</xsl:attribute>
                Encounter Details
            </xsl:element> <!-- </div> -->
            <xsl:element name="table">
                <xsl:attribute name="summary">ENCOUNTER_DETAILS_TABLE</xsl:attribute>
                <xsl:attribute name="class">detailsHalfTable</xsl:attribute>
                <xsl:element name="tbody">
                    <xsl:if test="$encounterStartDateTime!=''">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$cdaDocumentType='e-Discharge Summary'">Admission Date</xsl:when>
                                        <xsl:otherwise>Start Date</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:value-of select="$encounterStartDateTime"/>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                    <xsl:if test="$encounterEndDateTime!=''">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$cdaDocumentType='e-Discharge Summary'">Discharge Date</xsl:when>
                                        <xsl:otherwise>End Date</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$encounterEndDateTime"/>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                    <xsl:if test="$encounterDateTime!=''">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="$cdaDocumentType='Specialist Letter'">Date/Time Subject of Care Seen</xsl:when>
                                        <xsl:otherwise>Encounter Date</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$encounterDateTime"/>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                    <xsl:if test="$separationMode!=''">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Discharge To
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$separationMode"/>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                    <xsl:if test="$cdaDocumentType='e-Discharge Summary' and
                                  $dischargeLocation!=''">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Discharge From
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$dischargeLocation"/>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                    <xsl:if test="$cdaDocumentType='e-Discharge Summary' and
                        /cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:observation[cda:code/@code='103.16028' and cda:code/@codeSystem='1.2.36.1.2001.1001.101' and cda:code/@displayName='Specialty']/cda:value[(@displayName and (string-length(@displayName) &gt; 0)) or (cda:originalText and string-length(cda:originalText) &gt; 0)]">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Specialties
                                </xsl:element> <!-- </span> -->
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:element name="ul">
                                    <xsl:attribute name="class">specialtiesul</xsl:attribute>
                                    <xsl:for-each select="/cda:ClinicalDocument/cda:component/cda:structuredBody/cda:component/cda:section/cda:entry/cda:observation[cda:code/@code='103.16028' and cda:code/@codeSystem='1.2.36.1.2001.1001.101' and cda:code/@displayName='Specialty']/cda:value">
                                        <xsl:element name="li">
                                            <xsl:attribute name="class">specialtiesli</xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="./@code and 
                                                    (string-length(./@code) &gt; 0) and 
                                                    ./@codeSystem and 
                                                    (string-length(./@codeSystem) &gt; 0) and 
                                                    ./@displayName and 
                                                    (string-length(./@displayName) &gt; 0)">
                                                    <xsl:value-of select="./@displayName"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="./cda:originalText and string-length(./cda:originalText) &gt; 0"><xsl:value-of select="./cda:originalText/text()"/></xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                </xsl:element> <!-- </tbody> -->
            </xsl:element> <!-- </table> -->
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="getResponsibleHealthProfessionalAtTimeOfDischargeRow">
        <xsl:if test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/cda:name and
            string-length(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/cda:name) &gt; 0">
            <xsl:element name="div">
                <xsl:attribute name="style">margin-top: 10px;</xsl:attribute>                
                <xsl:attribute name="class">detailsHalfTableHeaderDiv</xsl:attribute>
                Responsible Health Professional At Time Of Discharge
            </xsl:element> 
            <xsl:element name="table">
                <xsl:attribute name="summary">RESPONSIBLE_HEALTH_PROFESSIONAL_AT_TIME_OF_DISCHARGE_TABLE</xsl:attribute>
                <xsl:attribute name="class">detailsHalfTable</xsl:attribute>
                <xsl:element name="tbody">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Name
                                </xsl:element>
                            </xsl:element> 
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:for-each select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/cda:name">
                                    <xsl:if test="position() > 1">
                                        <xsl:value-of select="$AKA_STRING"/>
                                    </xsl:if>
                                    <xsl:call-template name="show-name">
                                        <xsl:with-param name="name" select="."/>
                                    </xsl:call-template>
                                    <xsl:if test="position()!=last()">
                                        <xsl:element name="br"/>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/ext:asEntityIdentifier">
                                    <xsl:call-template name="getProviderIndividualIdentifier">
                                        <xsl:with-param name="entityIdentifier" select="."/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:element> 
                        </xsl:element>
                        
                        <xsl:call-template name="getAddressDetailsRows">
                            <xsl:with-param name="personOrOrg" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="getContactDetailsRows">
                            <xsl:with-param name="personOrOrg" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson"/>
                        </xsl:call-template>
                        
                        <xsl:if test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name and
                            string-length(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name) &gt; 0">
                            <xsl:element name="tr">
                                <xsl:element name="th">
                                    <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                        Organisation
                                    </xsl:element>
                                </xsl:element> 
                                <xsl:element name="td">
                                    <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                    <xsl:value-of select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name"/>
                                </xsl:element> 
                            </xsl:element>
                        </xsl:if>
                        
                        <xsl:if test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:name and
                            string-length(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:name) &gt; 0">
                            
                            <xsl:element name="tr">
                                <xsl:element name="th">
                                    <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                        Department
                                    </xsl:element>
                                </xsl:element> 
                                <xsl:element name="td">
                                    <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                    <xsl:value-of select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:encounterParticipant[@typeCode='DIS']/cda:assignedEntity/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:name"/>
                                </xsl:element> 
                            </xsl:element> 
                        </xsl:if>
                </xsl:element> <!-- </tbody> -->
            </xsl:element> <!-- </table> -->
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getSignificantParticipant">
        <xsl:param name="participant"/>
        <xsl:param name="participantTitle"/>
        
        <xsl:if test="$participant/cda:associatedEntity/cda:associatedPerson/cda:name and
            string-length($participant/cda:associatedEntity/cda:associatedPerson/cda:name) &gt; 0">
            <xsl:element name="div">
                <xsl:attribute name="style">margin-top: 10px;</xsl:attribute>                
                <xsl:attribute name="class">detailsHalfTableHeaderDiv</xsl:attribute>
                <xsl:value-of select="$participantTitle"/>
            </xsl:element> 
            <xsl:element name="table">
                <xsl:attribute name="class">detailsHalfTable</xsl:attribute>
                <xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                Name
                            </xsl:element>
                        </xsl:element> 
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:for-each select="$participant/cda:associatedEntity/cda:associatedPerson/cda:name">
                                <xsl:if test="position() > 1">
                                    <xsl:value-of select="$AKA_STRING"/>
                                </xsl:if>
                                <xsl:call-template name="show-name">
                                    <xsl:with-param name="name" select="."/>
                                </xsl:call-template>
                                <xsl:if test="position()!=last()">
                                    <xsl:element name="br"/>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="$participant/cda:associatedEntity/cda:associatedPerson/ext:asEntityIdentifier">
                                <xsl:call-template name="getProviderIndividualIdentifier">
                                    <xsl:with-param name="entityIdentifier" select="."/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:element> 
                    </xsl:element>
                    
                    <xsl:if test="count($participant/cda:associatedEntity/cda:addr) &gt; 0">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Address
                                </xsl:element>
                            </xsl:element> 
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:element name="dl">
                                    <xsl:attribute name="class">addressdl</xsl:attribute>
                                    <xsl:for-each select="$participant/cda:associatedEntity/cda:addr">
                                        <xsl:call-template name="getAddress">
                                            <xsl:with-param name="address" select="."/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:element> <!-- </dl> -->
                            </xsl:element> 
                        </xsl:element>
                    </xsl:if>
                    
                    <xsl:call-template name="getContactDetailsRows">
                        <xsl:with-param name="personOrOrg" select="$participant/cda:associatedEntity/cda:associatedPerson"/>
                    </xsl:call-template>
                                        
                    <xsl:if test="$participant/cda:associatedEntity/cda:associatedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name and
                        string-length($participant/cda:associatedEntity/cda:associatedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name) &gt; 0">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Organisation
                                </xsl:element>
                            </xsl:element> 
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$participant/cda:associatedEntity/cda:associatedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name"/>
                            </xsl:element> 
                        </xsl:element>
                    </xsl:if>
                    
                    <xsl:if test="$participant/cda:associatedEntity/cda:associatedPerson/ext:asEmployment/ext:employerOrganization/cda:name and
                        string-length($participant/cda:associatedEntity/cda:associatedPerson/ext:asEmployment/ext:employerOrganization/cda:name) &gt; 0">
                        
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Department
                                </xsl:element>
                            </xsl:element> 
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$participant/cda:associatedEntity/cda:associatedPerson/ext:asEmployment/ext:employerOrganization/cda:name"/>
                            </xsl:element> 
                        </xsl:element> 
                    </xsl:if>
                </xsl:element> <!-- </tbody> -->
            </xsl:element> <!-- </table> -->
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getFacilityDetails">
        <xsl:if test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name and 
            string-length(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name) &gt; 0">
            <xsl:element name="div">
                <xsl:attribute name="class">detailsHalfTableHeaderDiv</xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$cdaDocumentType='PCEHR Prescription Record'">Prescriber Organisation</xsl:when>
                    <xsl:when test="$cdaDocumentType='PCEHR Dispense Record'">Dispensing Organisation</xsl:when>
                    <xsl:otherwise>Facility</xsl:otherwise>
                </xsl:choose>
            </xsl:element> <!-- </div> -->
            <xsl:element name="table">
                <xsl:attribute name="summary">FACILITY_DETAILS_TABLE</xsl:attribute>
                <xsl:attribute name="class">detailsHalfTable</xsl:attribute>
                <xsl:element name="tbody">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Name
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name"/>
                                <xsl:for-each select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/ext:asEntityIdentifier">
                                    <xsl:call-template name="getProviderOrganisationIdentifier">
                                        <xsl:with-param name="entityIdentifier" select="."/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                        <xsl:for-each select="//ext:coverage2[@typeCode='COVBY']/ext:entitlement[@classCode='COV' and @moodCode='EVN' and ext:participant[@typeCode='HLD']/ext:participantRole[@classCode='SDLOC']]">
                            <xsl:if test="./ext:participant/ext:participantRole/ext:id/@root = /cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:id/@root">
                                
                                <xsl:variable name="entitlementType" select="ext:code/@displayName"></xsl:variable>
                                <xsl:variable name="entitlementNumber" select="ext:id/@extension"></xsl:variable>
                                
                                <xsl:element name="tr">
                                    <xsl:element name="th">
                                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="position()=1">
                                                    <xsl:text>Entitlements</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise/>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:element> <!-- </th> -->
                                    <xsl:element name="td">
                                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                        <xsl:value-of select="$entitlementNumber"/>
                                        <xsl:if test="$entitlementType and 
                                            string-length($entitlementType) &gt; 0">
                                            <xsl:text> (</xsl:text><xsl:value-of select="$entitlementType"/><xsl:text>)</xsl:text>
                                        </xsl:if>
                                    </xsl:element> <!-- </td> -->
                                </xsl:element> <!-- </tr> -->
                            </xsl:if>
                        </xsl:for-each>
                    
                        <xsl:call-template name="getAddressDetailsRows">
                            <xsl:with-param name="personOrOrg" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization"/>
                        </xsl:call-template>
                    
                        <xsl:call-template name="getContactDetailsRows">
                            <xsl:with-param name="personOrOrg" select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:asOrganizationPartOf/cda:wholeOrganization"/>
                        </xsl:call-template>
                        
                        <xsl:if test="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:name and
                            string-length(/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:name) &gt; 0">
                            <xsl:element name="tr">
                                <xsl:element name="th">
                                    <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                        Department
                                    </xsl:element> <!-- </span> -->
                                </xsl:element> <!-- </th> -->
                                <xsl:element name="td">
                                    <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                    <xsl:value-of select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/cda:name"/>
                                    <xsl:for-each select="/cda:ClinicalDocument/cda:componentOf/cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:serviceProviderOrganization/ext:asEntityIdentifier">
                                        <xsl:call-template name="getProviderOrganisationIdentifier">
                                            <xsl:with-param name="entityIdentifier" select="."/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:element> <!-- </td> -->
                            </xsl:element> <!-- </tr> -->
                        </xsl:if>
                </xsl:element> <!-- </tbody> -->
            </xsl:element> <!-- </table> -->
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getPatientDetailsAndDocumentDetailsTable">
        <xsl:element name="div">
            <xsl:attribute name="class">spacedSection pageWidthWithLeftMargin</xsl:attribute>
            <xsl:element name="table">
                <xsl:attribute name="class">detailsTable detailsTable--mod</xsl:attribute>                
                <xsl:element name="tr">
                    <xsl:attribute name="class">detailsTableTr</xsl:attribute>
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsTableTd</xsl:attribute>
                        <xsl:call-template name="getPatientDetails"/>
                        <xsl:if test="$cdaDocumentType='PCEHR Prescription Record' or $cdaDocumentType='PCEHR Dispense Record'">
                            <xsl:call-template name="getFacilityDetails"/>
                        </xsl:if>
                    </xsl:element> <!-- </td> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsTableTd</xsl:attribute>
                        <xsl:call-template name="getAuthorDetails"/>
                        <xsl:call-template name="getDocumentDetails"/>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->
                <xsl:choose>
                    <xsl:when test="$cdaDocumentType='e-Referral' and
                                   /cda:ClinicalDocument/cda:participant[@typeCode='REFT']/cda:associatedEntity/cda:associatedPerson/cda:name and
                                   string-length(/cda:ClinicalDocument/cda:participant[@typeCode='REFT']/cda:associatedEntity/cda:associatedPerson/cda:name) &gt; 0">
                        <xsl:element name="tr">
                            <xsl:attribute name="class">detailsTableTr</xsl:attribute>
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsTableTd</xsl:attribute>
                                <xsl:call-template name="getSignificantParticipant">
                                    <xsl:with-param name="participant" select="/cda:ClinicalDocument/cda:participant[@typeCode='REFT']"/>
                                    <xsl:with-param name="participantTitle">Referee</xsl:with-param>
                                </xsl:call-template>
                            </xsl:element> <!-- </td> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsTableTd</xsl:attribute>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:when>
                    <xsl:when test="$cdaDocumentType='Specialist Letter' and
                        /cda:ClinicalDocument/cda:participant[@typeCode='REFB']/cda:associatedEntity/cda:associatedPerson/cda:name and
                        string-length(/cda:ClinicalDocument/cda:participant[@typeCode='REFB']/cda:associatedEntity/cda:associatedPerson/cda:name) &gt; 0">
                        <xsl:element name="tr">
                            <xsl:attribute name="class">detailsTableTr</xsl:attribute>
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsTableTd</xsl:attribute>
                                <xsl:call-template name="getSignificantParticipant">
                                    <xsl:with-param name="participant" select="/cda:ClinicalDocument/cda:participant[@typeCode='REFB']"/>
                                    <xsl:with-param name="participantTitle">Referrer</xsl:with-param>
                                </xsl:call-template>
                            </xsl:element> <!-- </td> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsTableTd</xsl:attribute>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:when>
                </xsl:choose>
            </xsl:element> <!-- </table> -->
        </xsl:element> <!-- </div> -->
    </xsl:template>
    
    <xsl:template name="getPatientDetails">
        <xsl:variable name="deceasedTime">
            <xsl:if test="$patientDeceasedStatus='true' and
                /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:deceasedTime and
                /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:deceasedTime/@value and
                string-length(/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:deceasedTime/@value) &gt; 0">
                <xsl:call-template name="show-time">
                    <xsl:with-param name="datetime"
                        select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:deceasedTime"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:element name="table">
            <xsl:attribute name="summary">PATIENT_DETAILS_TABLE</xsl:attribute>
            <xsl:attribute name="class">detailsHalfTable</xsl:attribute>
            <xsl:element name="caption">
                <xsl:attribute name="class">sr-only-pdf</xsl:attribute>
                Administrative details for patient
            </xsl:element>
            <xsl:element name="thead">
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableHeaderDiv-mod</xsl:attribute>
                        Patient details
                    </xsl:element>
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableHeaderDiv-mod</xsl:attribute>
                        Value
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="tbody">
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Name
                        </xsl:element>
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                        <xsl:for-each select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name">
                            <xsl:if test="position() > 1">
                                <xsl:value-of select="$AKA_STRING"/>
                            </xsl:if>
                            <xsl:call-template name="show-patient-name">
                                <xsl:with-param name="name" select="."/>
                            </xsl:call-template>
                            <xsl:if test="position()!=last()">
                                <xsl:element name="br"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->

                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Sex
                        </xsl:element>
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                        <xsl:value-of select="$patientSex"/>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->

                <xsl:if test="string-length($patientIndigenousStatus) &gt; 0">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                Indigenous Status
                            </xsl:element>
                        </xsl:element> <!-- </th> -->
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:value-of select="$patientIndigenousStatus"/>
                        </xsl:element> <!-- </td> -->
                    </xsl:element> <!-- </tr> -->
                </xsl:if>

                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Date of Birth
                        </xsl:element>
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                        <xsl:value-of select="$patientDateOfBirth"/> (<xsl:value-of select="$patientAge"/>)
                        <xsl:if test="not($patientAge='DECEASED') and not($patientAge='AGE UNKNOWN') and string-length($patientCodedAge) = 0">
                            <xsl:element name="br"/>
                            <xsl:element name="div">
                                <xsl:attribute name="id">calculatedAgeAnchor</xsl:attribute>
                                <xsl:attribute name="name">calculatedAgeAnchor</xsl:attribute>
                                <xsl:attribute name="class">positionRelative</xsl:attribute>
                            </xsl:element>
                            <xsl:text>Age is calculated from date of birth</xsl:text>
                        </xsl:if>
                    </xsl:element>
                </xsl:element> <!-- </tr> -->

                <xsl:if test="$patientDeceasedStatus='true'">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                Status
                            </xsl:element>
                        </xsl:element> <!-- </th> -->
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:element name="span"><xsl:attribute name="style">font-weight: bold;</xsl:attribute>DECEASED</xsl:element>
                        </xsl:element>
                    </xsl:element> <!-- </tr> -->
                    
                    <xsl:if test="string-length($deceasedTime) &gt; 0">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Deceased Time
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$deceasedTime"/>
                            </xsl:element>
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                </xsl:if>
                
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Individual Healthcare Identifier (IHI)
                        </xsl:element>
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$patientIHI and
                                string-length($patientIHI) &gt; 0">
                                <xsl:value-of select="$patientIHI"/>
                            </xsl:when>
                            <xsl:otherwise>Not Provided</xsl:otherwise>
                        </xsl:choose>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->
                
                <xsl:for-each select="//ext:coverage2[@typeCode='COVBY']/ext:entitlement[@classCode='COV' and @moodCode='EVN' and ext:participant[@typeCode='BEN']/ext:participantRole[@classCode='PAT']]">
                    <xsl:if test="./ext:participant/ext:participantRole/ext:id/@root = /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:id/@root">
                        
                        <xsl:variable name="entitlementType" select="ext:code/@displayName"></xsl:variable>
                        <xsl:variable name="entitlementNumber" select="ext:id/@extension"></xsl:variable>
                        
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="position()=1">
                                            <xsl:text>Entitlements</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$entitlementNumber"/>
                                <xsl:if test="$entitlementType and 
                                    string-length($entitlementType) &gt; 0">
                                    <xsl:text> (</xsl:text><xsl:value-of select="$entitlementType"/><xsl:text>)</xsl:text>
                                </xsl:if>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>                    
                </xsl:for-each>

                <xsl:for-each select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/ext:asEntityIdentifier[@classCode='IDENT' and ext:id[@assigningAuthorityName!='IHI']]">
                    <xsl:if test="./ext:id and
                        ./ext:id/@root and
                        string-length(./ext:id/@root) &gt; 0 and
                        not(./ext:id/@displable='false') and
                        ./ext:code and
                        ./ext:code/@code and
                        string-length(./ext:code/@code) &gt; 0 and
                        ./ext:code/@codeSystem='2.16.840.1.113883.12.203'">
                        <xsl:variable name="identifier">
                            <xsl:choose>
                                <xsl:when test="./ext:id/@extension and
                                    string-length(./ext:id/@extension) &gt; 0">
                                    <xsl:value-of select="./ext:id/@extension"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="substring-after-last-occurance">
                                        <xsl:with-param name="string" select="./ext:id/@root"/>
                                        <xsl:with-param name="argument">.</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="identifierType">
                            <xsl:call-template name="getHL7V2Table0203IdentifierCodeDescription">
                                <xsl:with-param name="code" select="./ext:code/@code"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="identifierAssigningAuthorityName">
                            <xsl:if test="./ext:id/@assigningAuthorityName and
                                string-length(./ext:id/@assigningAuthorityName) &gt; 0">
                                <xsl:value-of select="./ext:id/@assigningAuthorityName"/>
                            </xsl:if>
                        </xsl:variable>
                        
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="position()=1">
                                            <xsl:text>Local Identifiers</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="$identifier"/>
                                <xsl:choose>
                                    <xsl:when test="$identifierAssigningAuthorityName and 
                                        string-length($identifierAssigningAuthorityName) &gt; 0">
                                        <xsl:text> (</xsl:text><xsl:value-of select="$identifierAssigningAuthorityName"/><xsl:text>)</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$identifierType and 
                                        string-length($identifierType) &gt; 0">
                                        <xsl:text> (</xsl:text><xsl:value-of select="$identifierType"/><xsl:text>)</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text> (Local Identifier)</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                </xsl:for-each>
                
                <xsl:call-template name="getContactDetailsRows">
                    <xsl:with-param name="personOrOrg" select="/cda:ClinicalDocument/cda:recordTarget/cda:patientRole"/>
                    <xsl:with-param name="IsPerson" select="'yes'"/>
                </xsl:call-template>
            </xsl:element> <!-- </tbody> -->
        </xsl:element> <!-- </table> -->
    </xsl:template>

    <xsl:template name="getAuthorDetails">
        <xsl:variable name="authorOrg" select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization/cda:name"/>
        <xsl:variable name="authorDepartment" select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEmployment/ext:employerOrganization/cda:name"/>
        
        <xsl:element name="div">
            <xsl:attribute name="class">detailsHalfTableHeaderDiv</xsl:attribute>
            <xsl:choose>
                <xsl:when test="$cdaDocumentType='PCEHR Prescription Record'">Prescriber</xsl:when>
                <xsl:when test="$cdaDocumentType='PCEHR Dispense Record'">Dispenser</xsl:when>
                <xsl:when test="$cdaDocumentType='Advance Care Information'">Uploaded by </xsl:when>
                <xsl:otherwise>Author</xsl:otherwise>
            </xsl:choose>
        </xsl:element> <!-- </div> -->
        <xsl:element name="table">
            <xsl:attribute name="summary">AUTHOR_DETAILS_TABLE</xsl:attribute>
            <xsl:attribute name="class">detailsHalfTable</xsl:attribute>
            <xsl:element name="caption">
                 <xsl:attribute name="class">sr-only</xsl:attribute>
            Administrative details for referee</xsl:element>
            <xsl:element name="tbody">
                <xsl:choose>
                    <xsl:when test="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedAuthoringDevice">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Device Name
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:value-of select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedAuthoringDevice/cda:softwareName/text()"/>
                                <xsl:for-each select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedAuthoringDevice/ext:asEntityIdentifier">
                                    <xsl:call-template name="getProviderDeviceIdentifier">
                                        <xsl:with-param name="entityIdentifier" select="."/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    Name
                                </xsl:element>
                            </xsl:element> <!-- </th> -->
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:for-each select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/cda:name">
                                    <xsl:if test="position() > 1">
                                        <xsl:value-of select="$AKA_STRING"/>
                                    </xsl:if>
                                    <xsl:call-template name="show-name">
                                        <xsl:with-param name="name" select="."/>
                                    </xsl:call-template>
                                    <xsl:if test="position()!=last()">
                                        <xsl:element name="br"/>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:code/@displayName and
                                    string-length(/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:code/@displayName) &gt; 0">
                                    <xsl:text> (</xsl:text><xsl:value-of select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:code/@displayName"/><xsl:text>)</xsl:text>
                                    <xsl:element name="br"/>
                                </xsl:if>
                                <xsl:for-each select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:assignedPerson/ext:asEntityIdentifier">
                                    <xsl:call-template name="getProviderIndividualIdentifier">
                                        <xsl:with-param name="entityIdentifier" select="."/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:element> <!-- </td> -->
                        </xsl:element> <!-- </tr> -->
                        
                        <xsl:for-each select="//ext:coverage2[@typeCode='COVBY']/ext:entitlement[@classCode='COV' and @moodCode='EVN' and ext:participant[@typeCode='HLD']/ext:participantRole[@classCode='ASSIGNED']]">
                            <xsl:if test="./ext:participant/ext:participantRole/ext:id/@root = /cda:ClinicalDocument/cda:author/cda:assignedAuthor/cda:id/@root">
                                
                                <xsl:variable name="entitlementType" select="ext:code/@displayName"></xsl:variable>
                                <xsl:variable name="entitlementNumber" select="ext:id/@extension"></xsl:variable>
                                
                                <xsl:element name="tr">
                                    <xsl:element name="th">
                                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="position()=1">
                                                    <xsl:text>Entitlements</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise/>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:element> <!-- </th> -->
                                    <xsl:element name="td">
                                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                        <xsl:value-of select="$entitlementNumber"/>
                                        <xsl:if test="$entitlementType and 
                                            string-length($entitlementType) &gt; 0">
                                            <xsl:text> (</xsl:text><xsl:value-of select="$entitlementType"/><xsl:text>)</xsl:text>
                                        </xsl:if>
                                    </xsl:element> <!-- </td> -->
                                </xsl:element> <!-- </tr> -->
                            </xsl:if>
                        </xsl:for-each>
                        
                        <xsl:if test="string-length($authorOrg) &gt; 0">
                            <xsl:element name="tr">
                                <xsl:element name="th">
                                    <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                        <xsl:text>Organisation</xsl:text>
                                    </xsl:element>
                                </xsl:element> <!-- </th> -->
                                <xsl:element name="td">
                                    <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                    <xsl:value-of select="$authorOrg"/>
                                </xsl:element> <!-- </td> -->
                            </xsl:element> <!-- </tr> -->
                        </xsl:if>

                        <xsl:if test="string-length($authorDepartment) &gt; 0">
                            <xsl:element name="tr">
                                <xsl:element name="th">
                                    <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                    <xsl:element name="span">
                                        <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                        <xsl:text>Department</xsl:text>
                                    </xsl:element>
                                </xsl:element> <!-- </th> -->
                                <xsl:element name="td">
                                    <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                    <xsl:value-of select="$authorDepartment"/>
                                </xsl:element> <!-- </td> -->
                            </xsl:element> <!-- </tr> -->
                        </xsl:if>
                        
                        <xsl:call-template name="getAddressDetailsRows">
                            <xsl:with-param name="personOrOrg" select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor"/>
                        </xsl:call-template>
                        
                        <xsl:call-template name="getContactDetailsRows">
                            <xsl:with-param name="personOrOrg" select="/cda:ClinicalDocument/cda:author/cda:assignedAuthor"/>
                        </xsl:call-template>
                        
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:element> <!-- </tbody> -->
        </xsl:element> <!-- </table> -->
    </xsl:template>
    
    <xsl:template name="getDocumentDetails">
        <xsl:variable name="documentId">
            <xsl:call-template name="getDocumentIdentifier">
                <xsl:with-param name="iiVariable" select="/cda:ClinicalDocument/cda:id"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="documentSetId">
            <xsl:call-template name="getDocumentIdentifier">
                <xsl:with-param name="iiVariable" select="/cda:ClinicalDocument/cda:setId"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="documentVersion" select="/cda:ClinicalDocument/cda:versionNumber/@value"/>
        
        <xsl:variable name="completionCode">
            <xsl:if test="/cda:ClinicalDocument/ext:completionCode and
                /cda:ClinicalDocument/ext:completionCode/@codeSystem and
                /cda:ClinicalDocument/ext:completionCode/@codeSystem='1.2.36.1.2001.1001.101.104.20104' and
                /cda:ClinicalDocument/ext:completionCode/@code and
                string-length(/cda:ClinicalDocument/ext:completionCode/@code) &gt; 0">
                <xsl:choose>
                    <xsl:when test="/cda:ClinicalDocument/ext:completionCode/@code='F'">Final</xsl:when>
                    <xsl:when test="/cda:ClinicalDocument/ext:completionCode/@code='I'">Interim</xsl:when>
                    <xsl:when test="/cda:ClinicalDocument/ext:completionCode/@code='W'">Withdrawn</xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        
        <xsl:variable name="dateTimeAttested">
            <xsl:call-template name="show-time">
                <xsl:with-param name="datetime" select="/cda:ClinicalDocument/cda:legalAuthenticator/cda:time"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="replacementStatusDocumentId">
            <xsl:call-template name="getDocumentIdentifier">
                <xsl:with-param name="iiVariable" select="/cda:ClinicalDocument/cda:relatedDocument[@typeCode='RPLC']/cda:parentDocument/cda:id"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="replacementStatus">
            <xsl:if test="string-length($replacementStatusDocumentId) &gt; 0">
                <xsl:value-of select="$replacementStatusDocumentId"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="transformStatusDocumentId">
            <xsl:call-template name="getDocumentIdentifier">
                <xsl:with-param name="iiVariable" select="/cda:ClinicalDocument/cda:relatedDocument[@typeCode='XFRM']/cda:parentDocument/cda:id"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="transformStatus">
            <xsl:if test="string-length($transformStatusDocumentId) &gt; 0">
                <xsl:value-of select="$transformStatusDocumentId"/>
            </xsl:if>
        </xsl:variable>
        <xsl:element name="table">            
            <xsl:attribute name="summary">DOCUMENT_DETAILS_TABLE</xsl:attribute>
            <xsl:attribute name="class">detailsHalfTable</xsl:attribute>
            <xsl:element name="caption">
                <xsl:attribute name="class">sr-only-pdf</xsl:attribute>
                Administrative clinical document details
            </xsl:element>
            <xsl:element name="thead">
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableHeaderDiv-mod</xsl:attribute>
                        Document details
                    </xsl:element>
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableHeaderDiv-mod</xsl:attribute>
                        Value
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="tbody">
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Document type
                        </xsl:element>
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$cdaDocumentType and
                                string-length($cdaDocumentType) &gt; 0">
                                <xsl:value-of select="$cdaDocumentType"/>
                            </xsl:when>
                            <xsl:otherwise>
                                Not Provided
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->
                
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Creation date and time
                        </xsl:element>
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$cdaDocumentCreationTime and
                                string-length($cdaDocumentCreationTime) &gt; 0">
                                <xsl:value-of select="$cdaDocumentCreationTime"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Not Provided</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->
                
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Date and time attested
                        </xsl:element>
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$dateTimeAttested and
                                string-length($dateTimeAttested) &gt; 0">
                                <xsl:value-of select="$dateTimeAttested"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Not Provided</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->
                
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Document identity
                        </xsl:element>
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="td">
                        <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$documentId and
                                string-length($documentId) &gt; 0">
                                <xsl:value-of select="$documentId"/>
                            </xsl:when>
                            <xsl:otherwise>
                                Not Provided
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element> <!-- </td> -->
                </xsl:element> <!-- </tr> -->
                
                <xsl:if test="$documentSetId and
                    string-length($documentSetId) &gt; 0">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                Document set identity
                            </xsl:element>
                        </xsl:element> <!-- </th> -->
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:value-of select="$documentSetId"/>
                        </xsl:element> <!-- </td> -->
                    </xsl:element> <!-- </tr> -->
                </xsl:if>

                <xsl:if test="$documentVersion and
                    string-length($documentVersion) &gt; 0">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                Document version
                            </xsl:element>
                        </xsl:element> <!-- </th> -->
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:value-of select="$documentVersion"/>
                        </xsl:element> <!-- </td> -->
                    </xsl:element> <!-- </tr> -->
                </xsl:if>

                <xsl:if test="$completionCode and
                    string-length($completionCode) &gt; 0">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                Completion code
                            </xsl:element>
                        </xsl:element> <!-- </th> -->
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="$completionCode='Withdrawn'">
                                    <xsl:element name="span"><xsl:attribute name="style">font-weight: bold;</xsl:attribute>WITHDRAWN</xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$completionCode"/>                                        
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element> <!-- </td> -->
                    </xsl:element> <!-- </tr> -->
                </xsl:if>

                <xsl:if test="string-length($replacementStatus) &gt; 0">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                Replaces Document ID
                            </xsl:element>
                        </xsl:element> <!-- </th> -->
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:value-of select="$replacementStatus"/>
                        </xsl:element>
                    </xsl:element> <!-- </tr> -->
                </xsl:if>

                <xsl:if test="string-length($transformStatus) &gt; 0">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                Source Record ID
                            </xsl:element>
                        </xsl:element> <!-- </th> -->
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:value-of select="$transformStatus"/>
                        </xsl:element>
                    </xsl:element> <!-- </tr> -->
                </xsl:if>
            </xsl:element> <!-- </tbody> -->
        </xsl:element> <!-- </table> -->
    </xsl:template>
    
    <!--================================================================================================================================================================================-->   
    <!-- [END] 1.2 TEMPLATES -->
    

    <!-- DETAILS TEMPLATES -->
    <!--================================================================================================================================================================================-->   
    <xsl:template name="getParticipantsTable">
        <xsl:param name="participants"/>
        <xsl:param name="title"></xsl:param>
        <xsl:param name="tableId"></xsl:param>
        
        <xsl:element name="h1">
            <xsl:attribute name="class">participantsHeader</xsl:attribute>
            &#160;Participants
        </xsl:element>
        <xsl:element name="table">
            <xsl:attribute name="id"><xsl:value-of select="$tableId"/></xsl:attribute>
            <xsl:attribute name="class">participantsTableClass</xsl:attribute>
            <xsl:attribute name="summary"><xsl:value-of select="$title"/></xsl:attribute>  
            <xsl:element name="caption">
                <xsl:attribute name="class">sr-only-pdf</xsl:attribute>
                Participants
            </xsl:element>          
            <xsl:element name="colgroup">
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$FIFTH_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$FIFTH_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$FIFTH_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$FIFTH_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$FIFTH_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
            </xsl:element>
            <xsl:element name="thead">
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">PARTICIPANT_HEADER_ROW_TH</xsl:attribute>
                        Name
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="th">
                        <xsl:attribute name="class">PARTICIPANT_HEADER_ROW_TH</xsl:attribute>
                        Contact
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="th">
                        <xsl:attribute name="class">PARTICIPANT_HEADER_ROW_TH</xsl:attribute>
                        Address
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="th">
                        <xsl:attribute name="class">PARTICIPANT_HEADER_ROW_TH</xsl:attribute>
                        Organisation
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="th">
                        <xsl:attribute name="class">PARTICIPANT_HEADER_ROW_TH</xsl:attribute>
                        Department
                    </xsl:element> <!-- </th> -->
                </xsl:element> <!-- </tr> -->
            </xsl:element> <!-- </thead> -->
            
            <xsl:element name="tbody">
                <xsl:for-each select="$participants">
                    <xsl:choose>
                        <xsl:when test="./@typeCode='PART' and cda:functionCode/@code='PCP'">
                            <xsl:choose>
                                <xsl:when test="$cdaDocumentType='e-Discharge Summary'">
                                    <xsl:call-template name="getParticipantsTableBodyRow">
                                        <xsl:with-param name="participantType">Nominated Primary Healthcare Provider Person</xsl:with-param>
                                    </xsl:call-template>            
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="getParticipantsTableBodyRow">
                                        <xsl:with-param name="participantType">Usual GP</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="./@typeCode='IRCP'">
                            <xsl:call-template name="getParticipantsTableBodyRow">
                                <xsl:with-param name="participantType">Patient's Nominated Contact</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="getParticipantsTableBodyRow"/>
                        </xsl:otherwise>
                    </xsl:choose>                    
                    
                </xsl:for-each>
            </xsl:element> <!-- </tbody> -->
        </xsl:element> <!-- </table> -->
    </xsl:template>
    
    <xsl:template name="getRecipientsTable">
        <xsl:param name="recipients"/>
        <xsl:param name="title"></xsl:param>
        <xsl:param name="tableId"></xsl:param>
        
        <xsl:element name="h1">
            <xsl:attribute name="class">participantsHeader</xsl:attribute>
            &#160;<xsl:value-of select="$title"/>
        </xsl:element>
        
        <xsl:element name="table">
            <xsl:attribute name="id"><xsl:value-of select="$tableId"/></xsl:attribute>
            <xsl:attribute name="class">participantsTableClass</xsl:attribute>
            <xsl:attribute name="summary"><xsl:value-of select="$title"/></xsl:attribute>
            <xsl:element name="caption">
                <xsl:attribute name="class">sr-only-pdf</xsl:attribute>
                Participants
            </xsl:element>
            <xsl:element name="colgroup">
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$QUARTER_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$QUARTER_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$QUARTER_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
                <xsl:element name="col">
                    <xsl:attribute name="style">width: <xsl:value-of select="$QUARTER_CONTENT_WIDTH_PCT"/>%;</xsl:attribute>
                </xsl:element> <!-- </col> -->
            </xsl:element>
            <xsl:element name="thead">
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">RECIPIENT_HEADER_ROW_TH</xsl:attribute>
                        Name
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="th">
                        <xsl:attribute name="class">RECIPIENT_HEADER_ROW_TH</xsl:attribute>
                        Contact
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="th">
                        <xsl:attribute name="class">RECIPIENT_HEADER_ROW_TH</xsl:attribute>
                        Address
                    </xsl:element> <!-- </th> -->
                    <xsl:element name="th">
                        <xsl:attribute name="class">RECIPIENT_HEADER_ROW_TH</xsl:attribute>
                        Organisation
                    </xsl:element> <!-- </th> -->
                </xsl:element> <!-- </tr> -->
            </xsl:element> <!-- </thead> -->
            
            <xsl:element name="tbody">
                <xsl:for-each select="$recipients">                    
                    <xsl:call-template name="getRecipientsTableBodyRow"/>
                </xsl:for-each>
            </xsl:element> <!-- </tbody> -->
        </xsl:element> <!-- </table> -->
    </xsl:template>

    <xsl:template name="getParticipantsTableBodyRow">
        <xsl:param name="participantType"/>
        <xsl:element name="tr">
            <xsl:element name="td">
                <xsl:attribute name="class">PARTICIPANT_BODY_ROW_TD</xsl:attribute>
                <xsl:for-each select="./cda:associatedEntity/cda:associatedPerson/cda:name">
                    <xsl:if test="position() > 1">
                        <xsl:value-of select="$AKA_STRING"/>
                    </xsl:if>
                    <xsl:call-template name="show-name">
                        <xsl:with-param name="name" select="."/>
                    </xsl:call-template>
                    <xsl:if test="$participantType and (string-length($participantType) &gt; 0)">
                        <xsl:value-of select="concat(' (', $participantType, ')')"/>
                    </xsl:if>
                    <xsl:element name="br"/>
                </xsl:for-each>
                <xsl:for-each select="./cda:associatedEntity/cda:associatedPerson/ext:asEntityIdentifier">
                    <xsl:call-template name="getProviderIndividualIdentifier">
                        <xsl:with-param name="entityIdentifier" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element> <!-- </td> -->

            <xsl:element name="td">
                <xsl:attribute name="class">PARTICIPANT_BODY_ROW_TD</xsl:attribute>
                <xsl:call-template name="getContactDetails">
                    <xsl:with-param name="personOrOrg" select="./cda:associatedEntity"/>
                </xsl:call-template>
            </xsl:element> <!-- </td> -->

            <xsl:element name="td">
                <xsl:attribute name="class">PARTICIPANT_BODY_ROW_TD</xsl:attribute>
                <xsl:if test="count(./cda:associatedEntity/cda:addr) &gt; 0">
                    <xsl:element name="dl">
                        <xsl:attribute name="class">addressdl</xsl:attribute>
                        <xsl:for-each select="./cda:associatedEntity/cda:addr">
                            <xsl:call-template name="getAddress">
                                <xsl:with-param name="address" select="."/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:element> <!-- </dl> -->
                </xsl:if>
            </xsl:element> <!-- </td> -->
            
            <xsl:element name="td">
                <xsl:attribute name="class">PARTICIPANT_BODY_ROW_TD</xsl:attribute>
                <xsl:for-each select="./cda:associatedEntity/cda:associatedPerson/ext:asEmployment/ext:employerOrganization/cda:asOrganizationPartOf/cda:wholeOrganization">
                    <xsl:for-each select="./cda:name">
                        <xsl:if test="string-length(.) &gt; 0">
                            <xsl:if test="position() > 1">
                                <xsl:value-of select="$AKA_STRING"/>
                            </xsl:if>
                            <xsl:value-of select="."/><xsl:element name="br"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="./ext:asEntityIdentifier">
                        <xsl:call-template name="getProviderOrganisationIdentifier">
                            <xsl:with-param name="entityIdentifier" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:element name="br"/>
                </xsl:for-each>
            </xsl:element> <!-- </td> -->

            <xsl:element name="td">
                <xsl:attribute name="class">PARTICIPANT_BODY_ROW_TD</xsl:attribute>
                <xsl:for-each select="./cda:associatedEntity/cda:associatedPerson/ext:asEmployment/ext:employerOrganization">
                    <xsl:for-each select="./cda:name">
                        <xsl:if test="string-length(.) &gt; 0">
                            <xsl:if test="position() > 1">
                                <xsl:value-of select="$AKA_STRING"/>
                            </xsl:if>
                            <xsl:value-of select="."/><xsl:element name="br"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="./ext:asEntityIdentifier">
                        <xsl:call-template name="getProviderOrganisationIdentifier">
                            <xsl:with-param name="entityIdentifier" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:element name="br"/>
                </xsl:for-each>
            </xsl:element> <!-- </td> -->
            
            
        </xsl:element> <!-- </tr> -->
    </xsl:template>
    
    <xsl:template name="getRecipientsTableBodyRow">
        <xsl:element name="tr">
            <xsl:element name="td">
                <xsl:attribute name="class">RECIPIENT_HEADER_ROW_TD</xsl:attribute>
                <xsl:for-each select="./cda:informationRecipient/cda:name">
                    <xsl:if test="position() > 1">
                        <xsl:value-of select="$AKA_STRING"/>
                    </xsl:if>
                    <xsl:call-template name="show-name">
                        <xsl:with-param name="name" select="."/>
                    </xsl:call-template>
                    <xsl:element name="br"/>
                </xsl:for-each>
                <xsl:for-each select="./cda:informationRecipient/ext:asEntityIdentifier">
                    <xsl:call-template name="getProviderIndividualIdentifier">
                        <xsl:with-param name="entityIdentifier" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element> <!-- </td> -->
            
            <xsl:element name="td">
                <xsl:attribute name="class">RECIPIENT_HEADER_ROW_TD</xsl:attribute>
                <xsl:call-template name="getContactDetails">
                    <xsl:with-param name="personOrOrg" select="."/>
                </xsl:call-template>
            </xsl:element> <!-- </td> -->
            
            <xsl:element name="td">
                <xsl:attribute name="class">RECIPIENT_HEADER_ROW_TD</xsl:attribute>
                <xsl:if test="count(./cda:addr) &gt; 0">
                    <xsl:element name="dl">
                        <xsl:attribute name="class">addressdl</xsl:attribute>
                        <xsl:for-each select="./cda:addr">
                            <xsl:call-template name="getAddress">
                                <xsl:with-param name="address" select="."/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:element> <!-- </dl> -->
                </xsl:if>
            </xsl:element> <!-- </td> -->
            
            <xsl:element name="td">
                <xsl:attribute name="class">RECIPIENT_HEADER_ROW_TD</xsl:attribute>
                <xsl:for-each select="./cda:receivedOrganization">
                    <xsl:for-each select="./cda:name">
                        <xsl:if test="string-length(.) &gt; 0">
                            <xsl:if test="position() > 1">
                                <xsl:value-of select="$AKA_STRING"/>
                            </xsl:if>
                            <xsl:value-of select="."/><xsl:element name="br"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="./ext:asEntityIdentifier">
                        <xsl:call-template name="getProviderOrganisationIdentifier">
                            <xsl:with-param name="entityIdentifier" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:element name="br"/>
                </xsl:for-each>
            </xsl:element> <!-- </td> -->
        </xsl:element> <!-- </tr> -->
    </xsl:template>
    
    <!--================================================================================================================================================================================-->
    <!-- [END] DETAILS TEMPLATES -->
    



    <!-- CDA BODY TEMPLATES -->
    <!--================================================================================================================================================================================-->
    
    <xsl:template name="processStructuredBody">
        <xsl:param name="structuredBody"/>
        <xsl:param name="processAdministrativeObservations"></xsl:param>
        <xsl:choose>
            <xsl:when test="$processAdministrativeObservations='yes'">
                <xsl:for-each select="$structuredBody/cda:component/cda:section">
                    <xsl:if test="(cda:code/@code='102.16080') and 
                                  (cda:code/@codeSystem='1.2.36.1.2001.1001.101') and 
                                  (cda:text) and 
                                  ( (string-length(normalize-space(cda:text/text())) &gt; 0) or (count(cda:text/*) &gt; 0))">
                        <xsl:call-template name="section"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$structuredBody/cda:component/cda:section">
                    <xsl:if test="not((cda:code/@code='102.16080') and (cda:code/@codeSystem='1.2.36.1.2001.1001.101'))">
                        <xsl:call-template name="section"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="cda:component/cda:nonXMLBody">
        <xsl:call-template name="processAttachment">
            <xsl:with-param name="element" select="."/>
        </xsl:call-template>
        <xsl:call-template name="getHorizontalSpacer"/>
    </xsl:template>
        
    <!--================================================================================================================================================================================-->
    <!-- [END] CDA BODY TEMPLATES -->




    <!-- CDA SECTION TEMPLATES -->
    <!--================================================================================================================================================================================-->

    <xsl:template name="section">
        <xsl:if test="cda:title">
            <xsl:choose>
                <xsl:when test="../../../../cda:component/cda:structuredBody">
                    <xsl:call-template name="section-title">
                        <xsl:with-param name="title" select="cda:title"/>
                        <xsl:with-param name="sectionId" select="./@ID"/>
                        <xsl:with-param name="margin">no</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="section-title">
                        <xsl:with-param name="title" select="cda:title"/>
                        <xsl:with-param name="sectionId" select="./@ID"/>
                        <xsl:with-param name="margin">yes</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:call-template name="section-text"/>
        <xsl:for-each select="cda:component/cda:section">
            <xsl:call-template name="nestedSection"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="getSectionPath">
        <xsl:param name="section"/>
        <xsl:param name="previousSectionTitle"/>
        <xsl:choose>
            <xsl:when test="$section/../../../cda:section">
                <xsl:call-template name="getSectionPath">
                    <xsl:with-param name="section" select="$section/../../../cda:section"/>
                    <xsl:with-param name="previousSectionTitle">
                        <xsl:choose>
                            <xsl:when test="$previousSectionTitle">
                                <xsl:choose>
                                    <xsl:when test="$section/cda:title and
                                        string-length($section/cda:title) &gt; 0">
                                        <xsl:value-of select="concat($section/cda:title, $SECTION_TITLE_NAVIGATION_SEPARATOR, $previousSectionTitle)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('Unlabeled Section', $SECTION_TITLE_NAVIGATION_SEPARATOR, $previousSectionTitle)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$section/cda:title and
                                        string-length($section/cda:title) &gt; 0">
                                        <xsl:value-of select="$section/cda:title"/>                                           
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>Unlabeled Section</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$section/cda:title and
                        string-length($section/cda:title) &gt; 0">
                        <xsl:value-of select="concat($section/cda:title, $SECTION_TITLE_NAVIGATION_SEPARATOR, $previousSectionTitle)"/>                       
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('Unlabeled Section', $SECTION_TITLE_NAVIGATION_SEPARATOR, $previousSectionTitle)"/>                       
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    
    <xsl:template name="section-title">
        <xsl:param name="title"/>
        <xsl:param name="sectionId"/>
        <xsl:param name="margin"/>
        <xsl:choose>
            <xsl:when test="contains($title, $SECTION_TITLE_NAVIGATION_SEPARATOR)">
                <xsl:variable name="actualSectionTitle">
                    <xsl:call-template name="substring-after-last-occurance">
                        <xsl:with-param name="string" select="$title"/>
                        <xsl:with-param name="argument" select="$SECTION_TITLE_NAVIGATION_SEPARATOR"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="leadIn">
                    <xsl:value-of select="concat(substring-before($title, concat($SECTION_TITLE_NAVIGATION_SEPARATOR, $actualSectionTitle)), $SECTION_TITLE_NAVIGATION_SEPARATOR)"/>
                </xsl:variable>
                <xsl:element name="h1">
                    <xsl:attribute name="class">nestedSectionHeader</xsl:attribute>
                    <xsl:if test="$margin='yes'">
                        <xsl:attribute name="style">margin-left: 2%;</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$sectionId and
                        string-length($sectionId) &gt; 0">
                        <xsl:element name="div">
                            <xsl:attribute name="id"><xsl:value-of select="$sectionId"/></xsl:attribute>
                            <xsl:attribute name="name"><xsl:value-of select="$sectionId"/></xsl:attribute>
                            <xsl:attribute name="class">positionRelative</xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:value-of select="$actualSectionTitle"/><span style="font-weight: normal; font-size: 9px;"><xsl:text> (</xsl:text><xsl:value-of select="$leadIn"/><span style="font-weight: bold;"><xsl:value-of select="$actualSectionTitle"/></span><xsl:text>)</xsl:text></span>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="h1">
                    <xsl:attribute name="class">sectionHeader</xsl:attribute>
                    <xsl:if test="$margin='yes'">
                        <xsl:attribute name="style">margin-left: 2%;</xsl:attribute>
                    </xsl:if>                    
                    <xsl:if test="$sectionId and
                        string-length($sectionId) &gt; 0">
                        <xsl:element name="div">
                            <xsl:attribute name="id"><xsl:value-of select="$sectionId"/></xsl:attribute>
                            <xsl:attribute name="name"><xsl:value-of select="$sectionId"/></xsl:attribute>
                            <xsl:attribute name="class">positionRelative</xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:value-of select="$title"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="section-text">
        <xsl:param name="margin"/>
        <xsl:element name="div">
            <xsl:choose>
                <xsl:when test="$margin='yes'">
                    <xsl:attribute name="class">sectionPageWidthMinusMargin</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">sectionPageWidth</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
                
            <xsl:if test="not(../../../../cda:component/cda:structuredBody)">
                <xsl:attribute name="style">margin-left: 20px;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="cda:text"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="nestedSection">
        
        
        <xsl:choose>
            <xsl:when test="cda:title and string-length(cda:title) &gt; 0">
                <xsl:choose>
                    <xsl:when test="../../../../cda:component/cda:structuredBody">
                        <xsl:call-template name="section-title">
                            <xsl:with-param name="title">
                                <xsl:call-template name="getSectionPath">
                                    <xsl:with-param name="section" select="."/>
                                    <xsl:with-param name="sectionId" select="./@ID"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="sectionId" select="./@ID"/>
                            <xsl:with-param name="margin">no</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="section-text">
                            <xsl:with-param name="margin">no</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="section-title">
                            <xsl:with-param name="title">
                                <xsl:call-template name="getSectionPath">
                                    <xsl:with-param name="section" select="."/>
                                    <xsl:with-param name="sectionId" select="./@ID"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="sectionId" select="./@ID"/>
                            <xsl:with-param name="margin">yes</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="section-text">
                            <xsl:with-param name="margin">yes</xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="../../../../cda:component/cda:structuredBody">
                        <xsl:call-template name="section-text">
                            <xsl:with-param name="margin">no</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="section-text">
                            <xsl:with-param name="margin">yes</xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>  
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:for-each select="cda:component/cda:section">
            <xsl:call-template name="nestedSection"/>
        </xsl:for-each>
    </xsl:template>
    
    <!--================================================================================================================================================================================-->
    <!-- [END] CDA SECTION TEMPLATES -->


    

    <!-- CDA NARRATIVE ELEMENT TEMPLATES -->    
    <!--================================================================================================================================================================================-->
    
    <xsl:template match="cda:footnote">
        <xsl:variable name="footnote-num">
            <xsl:number level="any" count="cda:footnote"/>
        </xsl:variable>
        <xsl:element name="sup">
            <xsl:element name="a">
                <xsl:attribute name="href">#F_footnote-<xsl:value-of select="$footnote-num"/></xsl:attribute>
                <xsl:attribute name="title">initialfootnote</xsl:attribute>
                <xsl:value-of select="$footnote-num"/>
            </xsl:element> <!-- </a> -->
        </xsl:element> <!-- </sup> -->
    </xsl:template>
    
    <xsl:template match="cda:footnote" mode="footnote">
        <xsl:variable name="footnote-num">
            <xsl:number level="any" count="cda:footnote"/>
        </xsl:variable>
        <xsl:element name="p">
            <xsl:element name="div">
                <xsl:attribute name="id">F_footnote-<xsl:value-of select="$footnote-num"/></xsl:attribute>
                <xsl:attribute name="name">F_footnote-<xsl:value-of select="$footnote-num"/></xsl:attribute>
                <xsl:attribute name="class">positionRelative</xsl:attribute>
            </xsl:element>
            <xsl:element name="span"><xsl:attribute name="style">font-weight: bold;</xsl:attribute>
                <xsl:text>[</xsl:text><xsl:value-of select="$footnote-num"/><xsl:text>] </xsl:text>
            </xsl:element>
            <xsl:apply-templates select="*|text()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="cda:footnoteRef">
        <xsl:variable name="theFootnote" select="//cda:footnote[@ID=current()/@IDREF]"/>
        <xsl:variable name="footnote-num">
            <xsl:for-each select="$theFootnote">
                <xsl:number level="any" count="cda:footnote"/>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:element name="sup">
            <xsl:element name="a">
                <xsl:attribute name="href">#<xsl:value-of select="concat('F_footnote-',$footnote-num)"/></xsl:attribute>
                <xsl:attribute name="title">ref#<xsl:value-of select="$footnote-num"/></xsl:attribute>
                <xsl:value-of select="$footnote-num"/>
            </xsl:element> <!-- </a> -->
        </xsl:element> <!-- </sup> -->
    </xsl:template>

    <xsl:template match="cda:linkHtml">
        <xsl:variable name="linkTargetContainsJavaScript">
            <xsl:call-template name="containsJavaScript"><xsl:with-param name="reference" select="./@href"></xsl:with-param></xsl:call-template>
        </xsl:variable>
        <xsl:if test="$linkTargetContainsJavaScript != 'true'">
        <xsl:if test="string-length(./@href) &gt; 0 or string-length(./text()) &gt; 0">
            <xsl:variable name="linkText">
                <xsl:choose>
                    <xsl:when test="string-length(./text()) &gt; 0">
                        <xsl:value-of select="./text()"/>  
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('link:',./@href)"/>
                    </xsl:otherwise>
                </xsl:choose>            
            </xsl:variable>
            <xsl:variable name="linkTarget">
                <xsl:choose>
                    <xsl:when test="string-length(./@href) &gt; 1 and starts-with(./@href, '#')">
                        <xsl:variable name="referenceId" select="substring-after(./@href, '#')"/>                    
                        <xsl:variable name="attachmentReference">
                            <xsl:choose>
                                <xsl:when test="//cda:observationMedia/@ID=$referenceId">true</xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$attachmentReference='true'">
                                <xsl:if test="//cda:observationMedia/@ID=$referenceId">
                                    <xsl:value-of select="//cda:observationMedia[@ID=$referenceId]/cda:value/cda:reference/@value"/>                            
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('#', $referenceId)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="not(starts-with(./@href, '#')) and string-length(./@href) &gt; 0">
                        <xsl:value-of select="./@href"/>
                    </xsl:when>
                </xsl:choose>    
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($linkTarget)=0">
                    <xsl:element name="a">
                        <xsl:value-of select="$linkText"/>
                    </xsl:element>                    
                </xsl:when>
                <xsl:otherwise>
                    <!-- Android hack -->
                    <xsl:choose>
                        <xsl:when test="($cdaDocumentType='Pathology Report' or $cdaDocumentType='Diagnostic Imaging Report' or $cdaDocumentType='Advance Care Information' or $cdaDocumentType='Pharmacist Shared Medicines List') and contains($linkTarget,'.pdf')">
                            <xsl:element name="div">
                                <xsl:attribute name="id">inlineAndroidPdf</xsl:attribute>
                            </xsl:element>
                            <xsl:choose>
                                <!-- for ipad we need to set the target -->
                                <xsl:when test="string-length($userAgent) &gt; 0 and $userAgent = 'iPad'">
                                    <xsl:element name="script">
                                        <xsl:attribute name="type">text/javascript</xsl:attribute>
                                        <![CDATA[
                                            var androidAgent = /Android/.test(navigator.userAgent);
                                            if(!androidAgent){
                                                //we display a simple link 
                                                $('#inlineAndroidPdf').append('<button class="close btn btn--primary internal-link" data-toggle="modal" data-target="#]]>myModal1<![CDATA[">]]><xsl:value-of select="$linkText"/><![CDATA[</button>');
                                            }
                                        ]]>
                                    </xsl:element>
									<xsl:call-template name="getAttachment">
					         <xsl:with-param name="value" select="concat('myModal1','')"/>
							 <xsl:with-param name="attachmentLink" select="concat($cViewerAttachmentPrefix,'AttachmentID=', $linkTarget, '&amp;AttachmentMimeType=application/pdf')"/>
                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="script">
                                        <xsl:attribute name="type">text/javascript</xsl:attribute>
                                        <![CDATA[
                                            var androidAgent = /Android/.test(navigator.userAgent);
                                            if(!androidAgent){
                                                //we display a simple link 
                                                $('#inlineAndroidPdf').append('<button class="close btn btn--primary internal-link" data-toggle="modal" data-target="#]]>myModal0<![CDATA[">]]><xsl:value-of select="$linkText"/><![CDATA[</button>');
                                            }
                                        ]]>
                                    </xsl:element>
									<xsl:call-template name="getAttachment">
					         <xsl:with-param name="value" select="concat('myModal0','')"/>
							 <xsl:with-param name="attachmentLink" select="concat($cViewerAttachmentPrefix,'AttachmentID=', $linkTarget, '&amp;AttachmentMimeType=application/pdf')"/>
                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="a">
                                 <xsl:if test="string-length($userAgent) &gt; 0 and $userAgent = 'iPad'">
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                </xsl:if>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$linkTarget"/>
                                </xsl:attribute>
                                <xsl:value-of select="$linkText"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        </xsl:if>
    </xsl:template>
    
    <xsl:template match="cda:content">
        <xsl:element name="span">
            <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
            <xsl:choose>
                <xsl:when test="@styleCode">
                    <xsl:call-template name="processStyleCode">
                        <xsl:with-param name="code" select="@styleCode"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element> <!-- </span> -->
    </xsl:template>

    <xsl:template match="cda:br">
        <xsl:element name="br">
           <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
           <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="cda:list">
        <xsl:if test="cda:caption and
            string-length(cda:caption) &gt; 0">
            <xsl:element name="span">
                <xsl:attribute name="class">listTableCaption</xsl:attribute>
                <xsl:value-of select="cda:caption"/>
            </xsl:element>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@styleCode">
                <xsl:choose>
                    <xsl:when test="@styleCode='Disc'">
                        <xsl:element name="ul">
                            <xsl:attribute name="class">genericul</xsl:attribute>
                            <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                            <xsl:attribute name="style">list-style-type: disc;</xsl:attribute>
                            <xsl:for-each select="cda:item">
                                <xsl:element name="li">
                                    <xsl:choose>
                                        <xsl:when test="@styleCode">
                                            <xsl:call-template name="processStyleCode">
                                                <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                                <xsl:with-param name="code" select="@styleCode"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    
                    <xsl:when test="@styleCode='Circle'">
                        <xsl:element name="ul">
                            <xsl:attribute name="class">genericul</xsl:attribute>
                            <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                            <xsl:attribute name="style">list-style-type: circle;</xsl:attribute>
                            <xsl:for-each select="cda:item">
                                <xsl:element name="li">
                                    <xsl:choose>
                                        <xsl:when test="@styleCode">
                                            <xsl:call-template name="processStyleCode">
                                                <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                                <xsl:with-param name="code" select="@styleCode"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    
                    <xsl:when test="@styleCode='Square'">
                        <xsl:element name="ul">
                            <xsl:attribute name="class">genericul</xsl:attribute>
                            <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                            <xsl:attribute name="style">list-style-type: square;</xsl:attribute>
                            <xsl:for-each select="cda:item">
                                <xsl:element name="li">
                                    <xsl:choose>
                                        <xsl:when test="@styleCode">
                                            <xsl:call-template name="processStyleCode">
                                                <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                                <xsl:with-param name="code" select="@styleCode"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:element name="ul">
                            <xsl:attribute name="class">genericul</xsl:attribute>
                            <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                            <xsl:for-each select="cda:item">
                                <xsl:element name="li">
                                    <xsl:choose>
                                        <xsl:when test="@styleCode">
                                            <xsl:call-template name="processStyleCode">
                                                <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                                <xsl:with-param name="code" select="@styleCode"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="ul">
                    <xsl:attribute name="class">genericul</xsl:attribute>
                    <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                    <xsl:for-each select="cda:item">
                        <xsl:element name="li">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
   </xsl:template>
   
    <xsl:template match="cda:list[@listType='ordered']">
        <xsl:if test="cda:caption and
            string-length(cda:caption) &gt; 0">
            <xsl:element name="span">
                <xsl:attribute name="class">listTableCaption</xsl:attribute>
                <xsl:value-of select="cda:caption"/>
            </xsl:element>
        </xsl:if>
        
      <xsl:choose>
         <xsl:when test="@styleCode">
            <xsl:choose>
               <xsl:when test="@styleCode='LittleRoman'">
                  <xsl:element name="ol">
                      <xsl:attribute name="class">genericol</xsl:attribute>
                      <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                     <xsl:attribute name="style">list-style-type: lower-roman;</xsl:attribute>
                     <xsl:for-each select="cda:item">
                        <xsl:element name="li">
                           <xsl:choose>
                              <xsl:when test="@styleCode">
                                 <xsl:call-template name="processStyleCode">
                                    <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                    <xsl:with-param name="code" select="@styleCode"/>
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:when>

               <xsl:when test="@styleCode='BigRoman'">
                  <xsl:element name="ol">
                      <xsl:attribute name="class">genericol</xsl:attribute>
                      <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                     <xsl:attribute name="style">list-style-type: upper-roman;</xsl:attribute>
                     <xsl:for-each select="cda:item">
                        <xsl:element name="li">
                           <xsl:choose>
                              <xsl:when test="@styleCode">
                                 <xsl:call-template name="processStyleCode">
                                    <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                    <xsl:with-param name="code" select="@styleCode"/>
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:when>

               <xsl:when test="@styleCode='LittleAlpha'">
                  <xsl:element name="ol">
                      <xsl:attribute name="class">genericol</xsl:attribute>
                      <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                     <xsl:attribute name="style">list-style-type: lower-alpha;</xsl:attribute>
                     <xsl:for-each select="cda:item">
                        <xsl:element name="li">
                           <xsl:choose>
                              <xsl:when test="@styleCode">
                                 <xsl:call-template name="processStyleCode">
                                    <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                    <xsl:with-param name="code" select="@styleCode"/>
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:when>

               <xsl:when test="@styleCode='BigAlpha'">
                  <xsl:element name="ol">
                      <xsl:attribute name="class">genericol</xsl:attribute>
                      <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                     <xsl:attribute name="style">list-style-type: upper-alpha;</xsl:attribute>
                     <xsl:for-each select="cda:item">
                        <xsl:element name="li">
                           <xsl:choose>
                              <xsl:when test="@styleCode">
                                 <xsl:call-template name="processStyleCode">
                                    <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                    <xsl:with-param name="code" select="@styleCode"/>
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:when>

               <xsl:otherwise>
                  <xsl:element name="ol">
                      <xsl:attribute name="class">genericol</xsl:attribute>
                      <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
                     <xsl:for-each select="cda:item">
                        <xsl:element name="li">
                           <xsl:choose>
                              <xsl:when test="@styleCode">
                                 <xsl:call-template name="processStyleCode">
                                    <xsl:with-param name="initialCssClasses"></xsl:with-param>
                                    <xsl:with-param name="code" select="@styleCode"/>
                                 </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:apply-templates/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
             <xsl:element name="ol">
                 <xsl:attribute name="class">genericol</xsl:attribute>
                 <xsl:call-template name="addID"><xsl:with-param name="element" select="."/></xsl:call-template>
               <xsl:for-each select="cda:item">
                  <xsl:element name="li">
                     <xsl:choose>
                        <xsl:when test="@styleCode">
                           <xsl:call-template name="processStyleCode">
                              <xsl:with-param name="initialCssClasses"></xsl:with-param>
                              <xsl:with-param name="code" select="@styleCode"/>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:apply-templates/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:element>
               </xsl:for-each>
             </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

    <xsl:template match="cda:caption"/>
   
    <xsl:template match="cda:table">
        <xsl:element name="table">
            <xsl:attribute name="class">generictable generictable--mod generictable--mod-padding</xsl:attribute>
            <xsl:call-template name="addID">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>

            <xsl:choose>
                <xsl:when test="cda:caption and
                    string-length(cda:caption) &gt; 0">
                    
                    <xsl:attribute name="summary">GENERIC TABLE</xsl:attribute>
                    <xsl:element name="caption">
                        <xsl:attribute name="class">listTableCaption</xsl:attribute>
                        <xsl:value-of select="cda:caption"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="summary">no summary</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="cda:thead">
        <xsl:element name="thead">
            <xsl:call-template name="addID">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>

            <xsl:apply-templates/>
        </xsl:element> <!-- </thead> -->
    </xsl:template>
   
    <xsl:template match="cda:tbody">
        <xsl:element name="tbody">
            <xsl:call-template name="addID">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   
    <xsl:template match="cda:tr">
        <xsl:if test="./@ID and string-length(./@ID) &gt; 0">
            <xsl:element name="div">
                <xsl:attribute name="id"><xsl:value-of select="./@ID"/></xsl:attribute>
                <xsl:attribute name="name"><xsl:value-of select="./@ID"/></xsl:attribute>
                <xsl:attribute name="class">positionRelative</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="tr">
           <xsl:attribute name="class">generictr</xsl:attribute>

           <xsl:apply-templates/>
       </xsl:element>
    </xsl:template>

    <xsl:template match="cda:th">
        <xsl:if test="./@ID and
            string-length(./@ID) &gt; 0">
            <xsl:element name="div">
                <xsl:attribute name="id"><xsl:value-of select="./@ID"/></xsl:attribute>
                <xsl:attribute name="name"><xsl:value-of select="./@ID"/></xsl:attribute>
                <xsl:attribute name="class">positionRelative</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:element name="th">
            <xsl:if test="./@colspan">
                <xsl:attribute name="colspan"><xsl:value-of select="./@colspan"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="./@rowspan">
                <xsl:attribute name="rowspan"><xsl:value-of select="./@rowspan"/></xsl:attribute>
            </xsl:if>
            <xsl:variable name="colWidthStyle">
                <xsl:choose>
                    <xsl:when test="./@styleCode and contains(./@styleCode, 'xColWidthPx')">
                        <xsl:call-template name="processColWidthPx">
                            <xsl:with-param name="code" select="./@styleCode"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="./@styleCode">
                    <xsl:choose>
                        <xsl:when test="contains(./@styleCode, 'rule') or contains(./@styleCode, 'Rule')">
                            <xsl:variable name="tableCellRuleCssClasses">
                                <xsl:call-template name="processTableCellStyleCode">
                                    <xsl:with-param name="code" select="./@styleCode"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:call-template name="processStyleCode">
                                <xsl:with-param name="initialCssClasses"><xsl:value-of select="$tableCellRuleCssClasses"/></xsl:with-param>
                                <xsl:with-param name="code" select="@styleCode"/>
                                <xsl:with-param name="initialStyles" select="$colWidthStyle"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="processStyleCode">
                                <xsl:with-param name="code" select="@styleCode"/>
                                <xsl:with-param name="initialCssClasses">genericth</xsl:with-param>
                                <xsl:with-param name="initialStyles" select="$colWidthStyle"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">genericth</xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="cda:td">
        <xsl:if test="./@ID and
            string-length(./@ID) &gt; 0">
            <xsl:element name="div">
                <xsl:attribute name="id"><xsl:value-of select="./@ID"/></xsl:attribute>
                <xsl:attribute name="name"><xsl:value-of select="./@ID"/></xsl:attribute>
                <xsl:attribute name="class">positionRelative</xsl:attribute>
            </xsl:element>
        </xsl:if>
       <xsl:element name="td">
         <xsl:if test="./@colspan">
             <xsl:attribute name="colspan"><xsl:value-of select="./@colspan"/></xsl:attribute>
         </xsl:if>
          <xsl:if test="./@rowspan">
              <xsl:attribute name="rowspan"><xsl:value-of select="./@rowspan"/></xsl:attribute>
          </xsl:if>
           <xsl:variable name="colWidthStyle">
               <xsl:choose>
                   <xsl:when test="./@styleCode and contains(./@styleCode, 'xColWidthPx')">
                       <xsl:call-template name="processColWidthPx">
                           <xsl:with-param name="code" select="./@styleCode"/>
                       </xsl:call-template>
                   </xsl:when>
                   <xsl:otherwise/>
               </xsl:choose>
           </xsl:variable>
           <xsl:choose>
            <xsl:when test="./@styleCode">
                <xsl:choose>
                    <xsl:when test="contains(./@styleCode, 'rule') or contains(./@styleCode, 'Rule')">
                        <xsl:variable name="tableCellRuleCssClasses">
                            <xsl:call-template name="processTableCellStyleCode">
                                <xsl:with-param name="code" select="./@styleCode"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="processStyleCode">
                            <xsl:with-param name="initialCssClasses"><xsl:value-of select="$tableCellRuleCssClasses"/></xsl:with-param>
                                <xsl:with-param name="code" select="@styleCode"/>
                                <xsl:with-param name="initialStyles" select="$colWidthStyle"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                       <xsl:call-template name="processStyleCode">
                           <xsl:with-param name="code" select="@styleCode"/>
                           <xsl:with-param name="initialCssClasses">generictd</xsl:with-param>
                           <xsl:with-param name="initialStyles" select="$colWidthStyle"/>
                       </xsl:call-template>
                    </xsl:otherwise>
                 </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="class">generictd</xsl:attribute>
               <xsl:apply-templates/>
            </xsl:otherwise>
         </xsl:choose>
       </xsl:element>
    </xsl:template>

    <xsl:template match="cda:renderMultiMedia">
        <xsl:call-template name="processAttachment">
            <xsl:with-param name="element" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="cda:paragraph">
        <xsl:element name="p">
            <xsl:call-template name="addID">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:attribute name="class">paragraph</xsl:attribute>
            <xsl:choose>
                <xsl:when test="@styleCode">
                    <xsl:call-template name="processStyleCode">
                        <xsl:with-param name="code" select="@styleCode"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element> <!-- </p> -->
    </xsl:template>
    
    <xsl:template match="cda:sup">
        <xsl:element name="sup">
            <xsl:call-template name="addID">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="cda:sub">
        <xsl:element name="sub">
            <xsl:call-template name="addID">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   
    <!--================================================================================================================================================================================-->
    <!-- [END] CDA NARRATIVE ELEMENT TEMPLATES -->


 
 
    <!-- STYLE CODE TEMPLATES -->    
    <!--================================================================================================================================================================================-->

    <xsl:template name="processStyleCode">
        <xsl:param name="code"/>
        <xsl:param name="initialCssClasses"/>
        <xsl:param name="initialStyles"/>
        
        <!-- Styles -->
        <xsl:variable name="colourStyles">
            <xsl:choose>
                <xsl:when test="contains($code, 'xFgColour') or
                                contains($code, 'xBgColour')">
                    <xsl:call-template name="processColourStyleCode">
                        <xsl:with-param name="code" select="$code"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="fontSizePxStyle">
            <xsl:choose>
                <xsl:when test="contains($code, 'xFontSizePx')">
                    <xsl:call-template name="processFontSizePx">
                        <xsl:with-param name="code" select="$code"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="fontSizeEmStyle">
            <xsl:choose>
                <xsl:when test="contains($code, 'xFontSizeEm')">
                    <xsl:call-template name="processFontSizeEm">
                        <xsl:with-param name="code" select="$code"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:attribute name="style">
            <xsl:call-template name="trim">
                <xsl:with-param name="string"><xsl:value-of select="concat($initialStyles, ' ', $colourStyles, ' ', $fontSizePxStyle, ' ', $fontSizeEmStyle)"/></xsl:with-param>
            </xsl:call-template>
        </xsl:attribute>
        
        <!-- Classes -->
        <xsl:variable name="boldClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'Bold')">
                    <xsl:text>bold</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="italicClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'Italic')">
                    <xsl:text>italic</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="underlineClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'Underline')">
                    <xsl:text>underline</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="emphasisClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'Emphasis')">
                    <xsl:text>emphasis</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="xFixedClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'xFixed')">
                    <xsl:text>xFixed</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:attribute name="class">
            <xsl:call-template name="trim">
                <xsl:with-param name="string"><xsl:value-of select="concat($initialCssClasses, ' ', $boldClass, ' ', $italicClass, ' ', $underlineClass, ' ', $emphasisClass, ' ', $xFixedClass)"/></xsl:with-param>
            </xsl:call-template>
        </xsl:attribute>
        
        <!-- pre element -->
        <xsl:choose>
            <xsl:when test="contains($code, 'xPre')">
                <xsl:element name="pre">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="processTableCellStyleCode">
        <xsl:param name="code"/>
        <xsl:param name="initialCssClasses"/>
        
        <!-- Classes -->
        <xsl:variable name="lRuleClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'Lrule')">
                    <xsl:text>Lrule</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="rRuleClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'Rrule')">
                    <xsl:text>Rrule</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="topruleClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'Toprule')">
                    <xsl:text>toprule</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="botruleClass">
            <xsl:choose>
                <xsl:when test="contains($code, 'Botrule')">
                    <xsl:text>botrule</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="tableCellClasses">
            <xsl:if test="$initialCssClasses and string-length($initialCssClasses) &gt; 0">
                <xsl:value-of select="$initialCssClasses"/><xsl:text> </xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="string-length($lRuleClass) &gt; 0">
                    <xsl:value-of select="$lRuleClass"/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>noLrule </xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
                <xsl:when test="string-length($rRuleClass) &gt; 0">
                    <xsl:value-of select="$rRuleClass"/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>noRrule </xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
                <xsl:when test="string-length($topruleClass) &gt; 0">
                    <xsl:value-of select="$topruleClass"/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>noToprule </xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
                <xsl:when test="string-length($botruleClass) &gt; 0">
                    <xsl:value-of select="$botruleClass"/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>noBotrule </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="trim">
            <xsl:with-param name="string"><xsl:value-of select="$tableCellClasses"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="processColourStyleCode">
        <xsl:param name="code"/>
        
        <!-- Isolate xFgColour stylecode -->
        <xsl:variable name="fgColourStyleCodeStart" select="substring-after($code, 'xFgColour')"/>
        <xsl:variable name="fgColourHexCode">
            <xsl:choose>
                <xsl:when test="contains($fgColourStyleCodeStart, ' ')">
                    <xsl:value-of select="substring-before($fgColourStyleCodeStart, ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$fgColourStyleCodeStart"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        

        <xsl:variable name="validFgColourHexCode"><xsl:call-template name="validatateColourStyleCodeValue"><xsl:with-param name="styleCodeValue" select="$fgColourHexCode"/></xsl:call-template></xsl:variable>
        <!-- Isolate xBgColour stylecode -->
        <xsl:variable name="bgColourStyleCodeStart" select="substring-after($code, 'xBgColour')"/>
        <xsl:variable name="bgColourHexCode">
            <xsl:choose>
                <xsl:when test="contains($bgColourStyleCodeStart, ' ')">
                    <xsl:value-of select="substring-before($bgColourStyleCodeStart, ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$bgColourStyleCodeStart"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        

        <xsl:variable name="validBgColourHexCode"><xsl:call-template name="validatateColourStyleCodeValue"><xsl:with-param name="styleCodeValue" select="$bgColourHexCode"/></xsl:call-template></xsl:variable>
        <!-- generate style value -->
        <xsl:variable name="colourStyles">
            <xsl:choose>


                <xsl:when test="$validFgColourHexCode = 'true' and $validBgColourHexCode = 'true'">
                    <xsl:text>background: #</xsl:text>
                    <xsl:value-of select="$bgColourHexCode"/>
                    <xsl:text>;</xsl:text>
                    <xsl:text> color: #</xsl:text>
                    <xsl:value-of select="$fgColourHexCode"/>
                    <xsl:text>;</xsl:text>
                </xsl:when>


                <xsl:when test="$validFgColourHexCode = 'false' and $validBgColourHexCode ='true'">
                    <xsl:text>background: #</xsl:text>
                    <xsl:value-of select="$bgColourHexCode"/>
                    <xsl:text>;</xsl:text>
                </xsl:when>


                <xsl:when test="$validFgColourHexCode = 'true' and $validBgColourHexCode ='false'">
                    <xsl:text>color: #</xsl:text>
                    <xsl:value-of select="$fgColourHexCode"/>
                    <xsl:text>;</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="trim">
            <xsl:with-param name="string"><xsl:value-of select="$colourStyles"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="processFontSizePx">
        <xsl:param name="code"/>
        
        <!-- Isolate xFontSize stylecode -->
        <xsl:variable name="fontSizeStyleCodeStart" select="substring-after($code, 'xFontSizePx')"/>
        <xsl:variable name="fontSize">
            <xsl:choose>
                <xsl:when test="contains($fontSizeStyleCodeStart, ' ')">
                    <xsl:value-of select="substring-before($fontSizeStyleCodeStart, ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$fontSizeStyleCodeStart"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        

        <xsl:variable name="validPxFontSize"><xsl:call-template name="validatateNumericValue"><xsl:with-param name="value" select="$fontSize"/></xsl:call-template></xsl:variable>
        <!-- generate style value -->
        <xsl:variable name="fontSizePxStyle">
            <xsl:choose>


                <xsl:when test="$validPxFontSize = 'true'">
                    <xsl:text>font-size: </xsl:text>
                    <xsl:value-of select="$fontSize"/>
                    <xsl:text>px;</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="trim">
            <xsl:with-param name="string"><xsl:value-of select="$fontSizePxStyle"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="processColWidthPx">
        <xsl:param name="code"/>
        
        <!-- Isolate xColWidth stylecode -->
        <xsl:variable name="colWidthStyleCodeStart" select="substring-after($code, 'xColWidthPx')"/>
        <xsl:variable name="colWidth">
            <xsl:choose>
                <xsl:when test="contains($colWidthStyleCodeStart, ' ')">
                    <xsl:value-of select="substring-before($colWidthStyleCodeStart, ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$colWidthStyleCodeStart"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        

        <xsl:variable name="validColWidth"><xsl:call-template name="validatateNumericValue"><xsl:with-param name="value" select="$colWidth"/></xsl:call-template></xsl:variable>
        <!-- generate style value -->
        <xsl:variable name="colWidthStyle">
            <xsl:choose>


                <xsl:when test="$validColWidth = 'true'">
                    <xsl:text>width: </xsl:text>
                    <xsl:value-of select="$colWidth"/>
                    <xsl:text>px;</xsl:text>

                    <xsl:text> table-layout: auto;</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="trim">
            <xsl:with-param name="string"><xsl:value-of select="$colWidthStyle"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="processFontSizeEm">
        <xsl:param name="code"/>
        
        <!-- Isolate xFontSize stylecode -->
        <xsl:variable name="fontSizeStyleCodeStart" select="substring-after($code, 'xFontSizeEm')"/>
        <xsl:variable name="fontSize">
            <xsl:choose>
                <xsl:when test="contains($fontSizeStyleCodeStart, ' ')">
                    <xsl:value-of select="substring-before($fontSizeStyleCodeStart, ' ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$fontSizeStyleCodeStart"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        

        <xsl:variable name="validEmFontSize"><xsl:call-template name="validatateNumericValue"><xsl:with-param name="value" select="$fontSize"/></xsl:call-template></xsl:variable>
        <!-- generate style value -->
        <xsl:variable name="fontSizeEmStyle">
            <xsl:choose>


                <xsl:when test="$validEmFontSize = 'true'">
                    <xsl:text>font-size: </xsl:text>
                    <xsl:value-of select="$fontSize"/>
                    <xsl:text>em;</xsl:text>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="trim">
            <xsl:with-param name="string"><xsl:value-of select="$fontSizeEmStyle"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="validatateColourStyleCodeValue">
        <xsl:param name="styleCodeValue"/>
        <xsl:variable name="validHexColourCharacters">0123456789ABCDEFabcdef</xsl:variable>        
        <xsl:choose>
            <xsl:when test="string-length($styleCodeValue) = 6">
                <xsl:choose>
                    <xsl:when test="string-length(translate($styleCodeValue, $validHexColourCharacters, '')) = 0"><xsl:value-of select="'true'"/></xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'false'"/>        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    
    <xsl:template name="validatateNumericValue">
        <xsl:param name="value"/>
        <xsl:variable name="validNumericCharacters">0123456789</xsl:variable>        
        <xsl:choose>
            <xsl:when test="string-length(translate($value, $validNumericCharacters, '')) = 0"><xsl:value-of select="'true'"/></xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'false'"/>        
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--================================================================================================================================================================================-->
    <!-- [END] STYLE CODE TEMPLATES -->




    <!-- ATTACHMENT TEMPLATES -->    
    <!--================================================================================================================================================================================-->
    <!-- For Path and DI (Modification by Accenture) -->
    <xsl:template name="processPathorDIAttachment">
        <xsl:param name="element"/>
        <xsl:param name="externalDocumentAttachment"/>
            
                <xsl:variable name="mediaType">
                    <xsl:choose>
                        <xsl:when test="$externalDocumentAttachment='yes'">
                            <xsl:choose>
                                <xsl:when test="$element/cda:text/@mediaType">
                                    <xsl:value-of select="$element/cda:text/@mediaType"/>
                                </xsl:when>
                                <xsl:otherwise>text/plain</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$externalDocumentAttachment='no'">
                            <xsl:choose>
                                <xsl:when test="$element/cda:value/@mediaType">
                                    <xsl:value-of select="$element/cda:value/@mediaType"/>
                                </xsl:when>
                                <xsl:otherwise>text/plain</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>                         
                    </xsl:choose>
                </xsl:variable>    
        
        <xsl:variable name="referenceValue">
            <xsl:choose>
                <xsl:when test="$externalDocumentAttachment='yes'">
                    <xsl:choose>
                        <xsl:when test="$element/cda:text/cda:reference/@value">
                            <xsl:value-of select="$element/cda:text/cda:reference/@value"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$externalDocumentAttachment='no'">
                    <xsl:choose>
                        <xsl:when test="$element/cda:value/cda:reference/@value">
                            <xsl:value-of select="$element/cda:value/cda:reference/@value"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>                         
            </xsl:choose>
        </xsl:variable>  
        
        <xsl:variable name="documentId">
            <xsl:call-template name="getDocumentIdentifier">
                <xsl:with-param name="iiVariable" select="/cda:ClinicalDocument/cda:id"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$mediaType='application/pdf'">
                <xsl:element name="script">
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <![CDATA[
                    var getAcrobatInfo = function() {

		            var getBrowserName = function() {
		                return function() {
		                    var userAgent = navigator ? navigator.userAgent.toLowerCase() : "other";
		                    if(userAgent.indexOf("chrome") > -1){
		                        return "chrome";
		                    } else if(userAgent.indexOf("safari") > -1){
		                        return "safari";
		                    } else if(userAgent.indexOf("msie") > -1 || navigator.appVersion.indexOf('Trident/') > 0){
		                        return "ie";
		                    } else if(userAgent.indexOf("firefox") > -1){
		                        return "firefox";
		                    } else {
		                        //return "ie";
		                        return userAgent;
		                    }
		                }();
		            };
		
		            var getActiveXObject = function(name) {
		                try { return new ActiveXObject(name); } catch(e) {}
		            };
		
		            var getNavigatorPlugin = function(name) {
		                for(key in navigator.plugins) {
		                    var plugin = navigator.plugins[key];
		                    if(plugin.name == name) return plugin;
		                }
		            };
		
		            var getPDFPlugin = function() {
		                return this.plugin = this.plugin || function() {
		                    if(getBrowserName() == 'ie') {
		                        //
		                        // load the activeX control
		                        // AcroPDF.PDF is used by version 7 and later
		                        // PDF.PdfCtrl is used by version 6 and earlier
		                        return getActiveXObject('AcroPDF.PDF') || getActiveXObject('PDF.PdfCtrl');
		                    } else {
		                      //  return getNavigatorPlugin('Adobe Acrobat') || getNavigatorPlugin('Chrome PDF Viewer') || getNavigatorPlugin('WebKit built-in PDF');
		                      	return true;
		                    }
		                }();
		            };
		
		            var isAcrobatInstalled = function() {
		                return !!getPDFPlugin();
		            };
		
		            var getAcrobatVersion = function() {
		                try {
		                    var plugin = getPDFPlugin();
		
		                    if(getBrowserName() == 'ie') {
		                        var versions = plugin.GetVersions().split(',');
		                        var latest = versions[0].split('=');
		                        return parseFloat(latest[1]);
		                    }
		
		                    if(plugin.version) return parseInt(plugin.version);
		                    return plugin.name
		                }
		                catch(e) {
		                    return null;
		                }
		            }
		
		            //
		            // The returned object
		            //
		            return {
		                browser: getBrowserName(),
		                acrobat: isAcrobatInstalled() ? 'installed' : false,
		                acrobatVersion: getAcrobatVersion()
		            };
		        };
                    var iosAgent = /iPhone|iPod|iPad|Android/.test(navigator.userAgent);
                    if(!iosAgent){
                        $(function(){
                        	
                        	var info = getAcrobatInfo();
							if(info.acrobat == 'installed'){
                            	$('.media').media({width:950, height:1000, src: "]]><xsl:value-of select="concat($cViewerAttachmentPrefix,'AttachmentID=', $referenceValue, '&amp;AttachmentMimeType=', $mediaType)"/><![CDATA["});
                        	}
                        	else{
                        		$('#noPDFReader').append("To view this report you need a PDF viewer installed – you can download one from <a href='https://acrobat.adobe.com/us/en/acrobat/pdf-reader.html' target='_blank'>https://acrobat.adobe.com/us/en/acrobat/pdf-reader.html</a>.");
                        	}
                        });
                    }
                    
                    setTimeout(function(){
                        var iosAgent = /iPhone|iPod|iPad|Android/.test(navigator.userAgent);
                        if(iosAgent){
                            var iosVersion = /OS 8_/.test(navigator.userAgent);
                            if(iosVersion){
                                $('#printPdfDiv').addClass("mediaIOS");
                            }else{
                                $('#printPdfDiv').addClass("mediaIOS_7");
                            }
                        }else{
                            $('#printPdfDiv').addClass("mediaPrint");
                        }
                    }, 300);
					]]>
                </xsl:element>
                <xsl:element name="script">
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <![CDATA[

                         var printButton= document.getElementById('button0');
                         
                        
                        var index= 0;
                        var retries= 0;

                        var nextIteration = function() {
                        $("#print").addClass('loading').attr('disabled','disable');
                        var image = $('<img style="padding-bottom:0.5em;" />').loadImg(']]><xsl:value-of select="concat($cViewerPDFAttachmentPrefix, 'AttachmentID=', $referenceValue)"/><![CDATA[&AttachmentPageNumber=' + index).done(function() {
                                                              
                                $('#printPdfDiv').append(this);

                                index++;

                                if (index <= 500) {
                                    setTimeout(nextIteration, 5);
                                }else{
                                	$("#print").removeClass('loading').removeAttr("disabled");
                                }
                            }).fail(function(){                            
                                //retry
                                if(retries < 2){

                                    retries++;
                                    setTimeout(nextIteration, retries * 2000);
                                }else{
                           			$("#print").removeClass('loading').removeAttr("disabled");
                                }
                            });
                        };
                        
                        setTimeout(nextIteration, 500);

                        
                      
                    ]]>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$mediaType='text/rtf' or
                $mediaType='application/rtf' or
                $mediaType='text/plain' or
                $mediaType='text/html' or
                $mediaType='application/xhtml+xml' or
                $mediaType='application/xml' or
                $mediaType='image/tiff'">
                <xsl:if test="$referenceValue and string-length($referenceValue) &gt; 0">
                    <xsl:element name="a">
                        <xsl:call-template name="addID">
                            <xsl:with-param name="element" select="."/>
                        </xsl:call-template>
                        <xsl:attribute name="href">
                            <!--xsl:value-of select="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value"/-->
                            <xsl:value-of select="concat($cViewerAttachmentPrefix, 'AttachmentID=', $referenceValue, '&amp;AttachmentMimeType=', $mediaType)"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="cda:caption and
                                string-length(cda:caption) &gt; 0">
                                <xsl:value-of select="cda:caption"/>  
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$mediaType='application/pdf'">PDF document</xsl:when>
                                    <xsl:when test="$mediaType='text/rtf' or $mediaType='application/rtf'">RTF document</xsl:when>
                                    <xsl:when test="$mediaType='text/plain'">Text document</xsl:when>
                                    <xsl:when test="$mediaType='text/html'">HTML document</xsl:when>
                                    <xsl:when test="$mediaType='application/xhtml+xml'">XHTML document</xsl:when>
                                    <xsl:when test="$mediaType='application/xml'">XML document</xsl:when>
                                    <xsl:when test="$mediaType='image/tiff'">TIFF document</xsl:when>
                                    <xsl:otherwise>Document with unknown type</xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$mediaType='image/gif' or $mediaType='image/jpeg' or $mediaType='image/png' or $mediaType='image/bmp'">
                    <xsl:if test="$referenceValue and string-length($referenceValue) &gt; 0">
                        <xsl:element name="table">
                            <xsl:element name="caption">
                                <xsl:attribute name="class">sr-only-pdf</xsl:attribute>Image attachment
                            </xsl:element>
                            <xsl:call-template name="addID">
                                <xsl:with-param name="element" select="."/>
                            </xsl:call-template>
                            <xsl:element name="tbody">
                                <xsl:element name="tr">
                                    <xsl:element name="td">
                                        <xsl:attribute name="align">center</xsl:attribute>
                                        <xsl:element name="img">
                                            <xsl:attribute name="src">
                                                <!--xsl:value-of select="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value"/-->
                                                <xsl:value-of select="concat($cViewerAttachmentPrefix, 'AttachmentID=', $referenceValue, '&amp;AttachmentMimeType=', $mediaType)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="style">padding-bottom:0.5em; width:100%</xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:choose>
                                                    <xsl:when test="cda:caption and
                                                        string-length(cda:caption) &gt; 0">
                                                        <xsl:value-of select="cda:caption"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>Image Attachment</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                        </xsl:element> <!-- </img> -->
                                    </xsl:element> <!-- </td> -->
                                </xsl:element> <!-- </tr> -->
                                <xsl:element name="tr">
                                    <xsl:element name="td">
                                        <xsl:attribute name="align">center</xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="cda:caption and
                                                string-length(cda:caption) &gt; 0">
                                                <xsl:value-of select="cda:caption"/>
                                            </xsl:when>
                                            <xsl:otherwise>Image Attachment</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element> <!-- </td> -->
                                </xsl:element> <!-- </tr> -->
                            </xsl:element> <!-- </tbody> -->
                        </xsl:element> <!-- </table> -->
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        


    <xsl:template name="processAttachment">
        <xsl:param name="element"/>
        
        <xsl:variable name="referenceObjectId" select="$element/@referencedObject"/>
        <xsl:variable name="mediaType">
            <xsl:choose>
                <xsl:when test="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/@mediaType">
                    <xsl:value-of select="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/@mediaType"/>
                </xsl:when>
                <xsl:otherwise>text/plain</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="documentId">
            <xsl:call-template name="getDocumentIdentifier">
                <xsl:with-param name="iiVariable" select="/cda:ClinicalDocument/cda:id"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="linkTargetContainsJavaScript">
            <xsl:call-template name="containsJavaScript">
                <xsl:with-param name="reference" select="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value"/>        
            </xsl:call-template>
        </xsl:variable>
       
       <xsl:choose>
            <!-- android hack -->
            <xsl:when test="$mediaType='application/pdf'">
                <xsl:if test="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value and $linkTargetContainsJavaScript = 'false' and string-length(//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value) &gt; 0">
                    <xsl:element name="div">
                        <xsl:attribute name="id">inlineAndroidPdf</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="script">
                        <xsl:attribute name="type">text/javascript</xsl:attribute>
                        <![CDATA[
                            var index= 0;
                            var retries= 0;
                            var elementname = ']]><xsl:value-of select="concat('inlineAndroidPdf', $documentId)"/><![CDATA[';
                            var elementObj = $('#inlineAndroidPdf');
                            elementObj.attr('id', elementname);
                            var androidAgent = /Android/.test(navigator.userAgent);
                            if(androidAgent){
                                var nextIteration = function() {
                                    var image = $('<img style="padding-bottom:0.5em;" />').loadImg(']]><xsl:value-of select="concat($cViewerPDFAttachmentPrefix, 'AttachmentID=', //cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value)"/><![CDATA[&AttachmentPageNumber=' + index).done(function() {
                                        elementObj.append(this);

                                        index++;
                                        if (index <= 500) {
                                            setTimeout(nextIteration, 5);
                                        }
                                    }).fail(function(){                            
                                        //retry
                                        if(retries < 2){
                                            retries++;
                                            setTimeout(nextIteration, retries * 2000);
                                        }
                                    });
                                };
                                
                                setTimeout(nextIteration, 500);
                            }else{
                                //we display a simple link 
                               elementObj.append('<button class="close btn btn--primary internal-link" data-toggle="modal" data-target="#]]><xsl:value-of select="concat('myModal', translate(//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value,'[.]',''))"/><![CDATA[">]]><xsl:value-of select="cda:caption"/><![CDATA[</button>');
                            }
                        ]]>
                    </xsl:element>

					<xsl:call-template name="getAttachment">
					         <xsl:with-param name="value" select="concat('myModal', translate(//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value,'[.]',''))"/>
							 <xsl:with-param name="attachmentLink" select="concat($cViewerAttachmentPrefix, 'AttachmentID=', //cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value, '&amp;AttachmentMimeType=', $mediaType)"/>
                    </xsl:call-template>
				</xsl:if>
            </xsl:when>
            <!-- end hack for Android -->
            
            <xsl:when test="$mediaType='text/rtf' or
                $mediaType='application/rtf' or
                $mediaType='text/plain' or
                $mediaType='text/html' or
                $mediaType='application/xhtml+xml' or
                $mediaType='application/xml' or
                $mediaType='image/tiff'">
                <xsl:if test="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value and
                              $linkTargetContainsJavaScript = 'false' and
                              string-length(//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value) &gt; 0">
                    <xsl:element name="a">
                        <xsl:call-template name="addID">
                            <xsl:with-param name="element" select="."/>
                        </xsl:call-template>
                        <xsl:attribute name="href">
                            <!--xsl:value-of select="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value"/-->
                            <xsl:value-of select="concat($cViewerAttachmentPrefix, 'AttachmentID=', //cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value, '&amp;AttachmentMimeType=', $mediaType)"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="cda:caption and string-length(cda:caption) &gt; 0">
                                <xsl:value-of select="cda:caption"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$mediaType='application/pdf'">PDF document</xsl:when>
                                    <xsl:when test="$mediaType='text/rtf' or $mediaType='application/rtf'">RTF document</xsl:when>
                                    <xsl:when test="$mediaType='text/plain'">Text document</xsl:when>
                                    <xsl:when test="$mediaType='text/html'">HTML document</xsl:when>
                                    <xsl:when test="$mediaType='application/xhtml+xml'">XHTML document</xsl:when>
                                    <xsl:when test="$mediaType='application/xml'">XML document</xsl:when>
                                    <xsl:when test="$mediaType='image/tiff'">TIFF document</xsl:when>
                                    <xsl:otherwise>Document with unknown type</xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$mediaType='image/gif' or $mediaType='image/jpeg' or $mediaType='image/png' or $mediaType='image/bmp'">
                    <xsl:if test="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value and

                        $linkTargetContainsJavaScript = 'false' and
                        string-length(//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value) &gt; 0">
                        <xsl:element name="table">
                            <xsl:element name="caption">
                                <xsl:attribute name="class">sr-only-pdf</xsl:attribute>Image attachment
                            </xsl:element>
                            <xsl:call-template name="addID">
                                <xsl:with-param name="element" select="."/>
                            </xsl:call-template>
                            <xsl:element name="tbody">
                                <xsl:element name="tr">
                                    <xsl:element name="td">
                                        <xsl:attribute name="align">center</xsl:attribute>
                                        <xsl:element name="img">
                                            <xsl:attribute name="src">
                                                <!--xsl:value-of select="//cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value"/-->
                                             <xsl:value-of select="concat($cViewerAttachmentPrefix, 'AttachmentID=', //cda:observationMedia[@ID=$referenceObjectId]/cda:value/cda:reference/@value, '&amp;AttachmentMimeType=', $mediaType)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="style">padding-bottom:0.5em; width:100%</xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:choose>
                                                    <xsl:when test="cda:caption and
                                                        string-length(cda:caption) &gt; 0">
                                                        <xsl:value-of select="cda:caption"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>Image Attachment</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                        </xsl:element> <!-- </img> -->
                                    </xsl:element> <!-- </td> -->
                                </xsl:element> <!-- </tr> -->
                                <xsl:element name="tr">
                                    <xsl:element name="td">
                                        <xsl:attribute name="align">center</xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="cda:caption and
                                                string-length(cda:caption) &gt; 0">
                                                <xsl:value-of select="cda:caption"/>
                                            </xsl:when>
                                            <xsl:otherwise>Image Attachment</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element> <!-- </td> -->
                                </xsl:element> <!-- </tr> -->
                            </xsl:element> <!-- </tbody> -->
                        </xsl:element> <!-- </table> -->
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    
    <xsl:template name="renderLogo">
        <xsl:if test="//cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/png' or @mediaType='image/gif' or @mediaType='image/jpeg']/cda:reference/@value">






            <xsl:variable name="logoTargetContainsJavaScript">
                <xsl:call-template name="containsJavaScript">
                    <xsl:with-param name="reference" select="//cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/png' or @mediaType='image/gif' or @mediaType='image/jpeg']/cda:reference/@value"/>        
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:if test="$logoTargetContainsJavaScript = 'false'">
            <xsl:element name="img">
                <xsl:attribute name="id">LOGO</xsl:attribute>
                <xsl:attribute name="alt">logo</xsl:attribute>
                <xsl:attribute name="src">
                    <xsl:choose>
                        <xsl:when test="//cda:observationMedia[@ID='LOGO']/cda:value/@mediaType='image/png'">
                            <!--xsl:value-of select="//cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/png']/cda:reference/@value"/-->
                            <xsl:value-of select="concat($cViewerAttachmentPrefix, 'AttachmentID=', //cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/png']/cda:reference/@value, '&amp;AttachmentMimeType=', //cda:observationMedia[@ID='LOGO']/cda:value/@mediaType)" />
                        </xsl:when>
                        <xsl:when test="//cda:observationMedia[@ID='LOGO']/cda:value/@mediaType='image/gif'">
                            <!--xsl:value-of select="//cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/gif']/cda:reference/@value"/-->
                            <xsl:value-of select="concat($cViewerAttachmentPrefix, 'AttachmentID=', //cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/gif']/cda:reference/@value, '&amp;AttachmentMimeType=', //cda:observationMedia[@ID='LOGO']/cda:value/@mediaType)" />
                        </xsl:when>
                        <xsl:when test="//cda:observationMedia[@ID='LOGO']/cda:value/@mediaType='image/jpeg'">
                            <!--xsl:value-of select="//cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/jpeg']/cda:reference/@value"/-->
                            <xsl:value-of select="concat($cViewerAttachmentPrefix, 'AttachmentID=', //cda:observationMedia[@ID='LOGO']/cda:value[@mediaType='image/jpeg']/cda:reference/@value, '&amp;AttachmentMimeType=', //cda:observationMedia[@ID='LOGO']/cda:value/@mediaType)" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:element> <!-- </img> -->
        </xsl:if>

        </xsl:if>
    </xsl:template>
    <!-- [END] For Path and DI (Modification by Accenture) -->

    <!--================================================================================================================================================================================-->
    <!-- [END] ATTACHMENT TEMPLATES -->
    
    
    <xsl:template name="addJavascript">
    
        <xsl:variable name="documentId">
            <xsl:call-template name="getDocumentIdentifier">
                <xsl:with-param name="iiVariable" select="/cda:ClinicalDocument/cda:id"/>
            </xsl:call-template>
        </xsl:variable>

        
           
        <xsl:if test="$activateAlertMessage = 'Y'">
            <script type="text/javascript">
                <![CDATA[
                window.onload = function(){
                    //add the css with the styles for the message banner
                    var link = $("<link id='ncpformlink'>");
                    link.attr({
                        type: 'text/css',
                        rel: 'stylesheet',
                        href: '/static/20130424/branding/ncp/ncp-forms.css'
                    });
                    var jsMedicare = document.getElementById("CDB_Medicare").innerHTML;
                                        
                    //remove first and then add the css to the toolbar iframe
                    $('#ncpformlink', window.parent.document).remove();
                    $('head', window.parent.document).append( link );
                    $('#info-manage-doc-access', window.parent.document).remove();

                    //resize the page as the message needs some space
                    var pageHeight = $('body').height();
                    $('body').height( pageHeight + 100);
                    
                    //register a listener to remove the message once the user change the page
                    var iosAgent = /iPhone|iPod|iPad|Android/.test(navigator.userAgent);
                    if(iosAgent){
                        window.addEventListener("pagehide", function(evt){
                            var elem= window.parent.document.getElementById('info-manage-doc-access');
                            try{
                                if(elem && elem.parentNode){
                                    elem.parentNode.removeChild(elem);
                                }
                            }catch(e){
                                elem.remove();
                            }
                        }, false);
                    }else{
                        $(window).on('beforeunload', function(){
                            var elem= window.parent.document.getElementById('info-manage-doc-access');
                            try{
                                if(elem && elem.parentNode){
                                    elem.parentNode.removeChild(elem);
                                }
                            }catch(e){
                                elem.remove();
                            }
                        });
                    }
                };]]>
            </script>
        </xsl:if>

        <script type="text/javascript">
      //      <![CDATA[
            //add toolbar in case the document has been opened directly
            
    //        $("#cdv-controlbar", window.parent.document).focus();
    //        var printButton= parent.document.getElementById("button0");
	//		if(printButton){
	//			var historybutton = parent.document.getElementById('button1');
	//			if(historybutton.getAttribute('class') == 'showhistory'){
	//				historybutton.removeAttribute('onclick');
	//			//	historybutton.setAttribute("onclick", "showHistory(\'PCEHR_Consumer\', \'INSECURE_Consumer_Change_History_View_EP\', \']]><xsl:value-of select="$repoId"/><![CDATA[\', \']]><xsl:value-of select="$pcehrDocumentId"/><![CDATA[\')");
	//				}
     //       }
            //if no print button, we create the toolbar.
      //      if(!printButton){
      //          $("#cdv-controlbar", window.document).addClass("document-loaded");
				
     //           $("#cdv-controlbar", window.document).append('<ul class="bd separated" id="buttons"></ul>');
     //           var showHistory = document.getElementById("button1");
     //           if(!showHistory){
     //           $("#buttons", window.document).append('<li><a class="" id="button0" href="#" onclick="javascript:window.print();">Print</a></li>');
     //           $("#buttons", window.document).append('<li><a class="showhistory" id="button1" href="#">Show History</a></li>');
	//			}
				
			//	var cdv = document.getElementsByClassName("yui3-widget-bd");
									
			//	var styleheight = (cdv[1].getAttribute("style"));
			//	styleheight = styleheight.replace("height: ","");
			//	styleheight = styleheight.replace("px;","");
					
			//	var newheight = parseInt(styleheight) - 27;
			//	var newstyle = "height: " + newheight + "px;";
			//	cdv[1].removeAttribute("style");
			//	cdv[1].setAttribute("style", newstyle);
		//	}
            
            var chromeAgent = /Chrome/.test(navigator.userAgent);
        //    if(chromeAgent && printButton){
        //        printButton.focus();
         //       printButton.blur();
        //    }
        //    ]]>
      //  </script>
		
       

        <xsl:choose>
            <xsl:when test="$isReadOnlyActivated != 'true'">
                <xsl:if test="($relationship = 'Authorised Representative' or $relationship = 'Individual' or $relationship = 'Full Access Nominated Representative')">
                    <xsl:choose>
                        <xsl:when test="($cdaDocumentType != 'Shared Health Summary' and $cdaDocumentType != 'Advance Care Directive Custodian Record' and $cdaDocumentType != 'Consumer Entered Health Summary' and $cdaDocumentType != 'Advance Care Information')">
                            <script type="text/javascript"><![CDATA[
                                if(!printButton){
                                    $("#buttons", window.parent.document).append('<li><a class="" id="button2" href="#" onclick="manageAccess(\'PCEHR_Consumer\', \'INSECURE_Consumer_Change_Document_Access_Level_EP\', \']]><xsl:value-of select="$repoId"/><![CDATA[\', \']]><xsl:value-of select="$pcehrDocumentId"/><![CDATA[\')">Manage Access</a></li>');
                                    $("#buttons", window.parent.document).append('<li><a class="" id="button3" href="#" onclick="removeDocument(\'PCEHR_Consumer\', \'INSECURE_Consumer_Remove_Document_EP\', \']]><xsl:value-of select="$repoId"/><![CDATA[\', \']]><xsl:value-of select="$pcehrDocumentId"/><![CDATA[\')">Remove</a></li>');
                                }]]>
                            </script>
                        </xsl:when>
                        <xsl:otherwise>
						<xsl:choose>
							<xsl:when test="($cdaDocumentType != 'Advance Care Information')">
								<script type="text/javascript">
									<![CDATA[
										if(!printButton){
										
												$("#buttons", window.parent.document).append('<li><a class="" id="button2" href="#" onclick="removeDocument(\'PCEHR_Consumer\', \'INSECURE_Consumer_Remove_Document_EP\', \']]><xsl:value-of select="$repoId"/><![CDATA[\', \']]><xsl:value-of select="$pcehrDocumentId"/><![CDATA[\')">Remove</a></li>');
											}
										]]>
								</script>
							</xsl:when>
							<xsl:otherwise>
								<script type="text/javascript">
									<![CDATA[
										if(!printButton){
										
												$("#buttons", window.parent.document).append('<li><a class="" id="button1" href="#" onclick="removeDocument(\'PCEHR_Consumer\', \'INSECURE_Consumer_Remove_Document_EP\', \']]><xsl:value-of select="$repoId"/><![CDATA[\', \']]><xsl:value-of select="$pcehrDocumentId"/><![CDATA[\')">Remove</a></li>');
											}
										]]>
								</script>
							</xsl:otherwise>
							</xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="($relationship = 'Authorised Representative' or $relationship = 'Individual' or $relationship = 'Full Access Nominated Representative')">
                    <!-- disable links -->
                    <script type="text/javascript"><![CDATA[
                        if(!printButton){
                            $("#buttons", window.parent.document).append('<li><a class="btn-disabled" id="button2" href="#" >Manage Access</a></li>');
                            $("#buttons", window.parent.document).append('<li><a class="btn-disabled" id="button3" href="#" >Remove</a></li>');
                        }]]>
                    </script>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        
        <script type="text/javascript">
            <![CDATA[
      //      window.setTimeout(function() {
      //          enablePrintButton();
      //      }, 120000);
            
     //       function enablePrintButton(){
     //           var printButton= parent.document.getElementById('button0');
     //           if(printButton){
    //                printButton.disabled = false;
    //                printButton.style.visibility = 'visible';
    //                printButton.setAttribute('href', '#');
                    
                    //remove the image from the toolbar
    //                var imgLoadingPrint = parent.document.getElementById('imgLoadingPrint');
    //                if(imgLoadingPrint){
    //                    printButton.parentNode.removeChild(imgLoadingPrint);
    //                }
    //            }
    //        };
            
            $.fn.extend({
                loadImg: function(url, timeout) {
                
                    // init deferred object
                    var defer = $.Deferred(),
                        $img = this,
                        img = $img.get(0),
                        timer = null;

                    // define load and error events BEFORE setting the src
                    // otherwise IE might fire the event before listening to it
                    $img.bind("load", function(e) {
                        var that = this;

                        window.setTimeout(function() {
                            defer.resolveWith($img);
                        }, 50);
                        
                    }).error(function(e) {
                        defer.rejectWith($img);
                    });

                    img.src = url + '&random=' + (new Date()).getTime();
                    
                    
                    // check if it's already in the cache
                    if (img.complete) {
                        defer.resolveWith($img);
                    } else if (0 !== timeout) {
                        // add a timeout, by default 15 seconds
                        timer = window.setTimeout(function() {
                            defer.rejectWith($img);
                        }, timeout || 15000);
                    }

                    // return the promise of the deferred object
                    return defer.promise().always(function() {
                        // stop the timeout timer
                        window.clearTimeout(timer);
                        timer = null;
                        // unbind the load and error event
                        this.off("load error");
                    });
                }
            });]]>
        </script>
    </xsl:template>
    <!-- STRUCTURE TEMPLATES -->    
    <!--================================================================================================================================================================================-->
 
    <xsl:template name="getHorizontalSpacer">
        <xsl:element name="div">
            <xsl:attribute name="class">horizontalspacer</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="getFootnotesTable">
        <xsl:if test="count(//cda:footnote) &gt; 0">
            <xsl:element name="h1">
                <xsl:attribute name="class">participantsHeader</xsl:attribute>
                Footnotes
            </xsl:element>
            <xsl:element name="table">
                <xsl:attribute name="class">participantsTableClass participantsTableClass-mod</xsl:attribute>
                <xsl:element name="caption">
                    <xsl:attribute name="class">sr-only-pdf</xsl:attribute>Foot notes
                </xsl:element>
                <xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="td"><xsl:apply-templates mode="footnote" select=".//cda:footnote"/></xsl:element>
                    </xsl:element> <!-- </tr> -->
                </xsl:element> <!-- </tbody> -->
            </xsl:element> <!-- </table> -->            
        </xsl:if>
    </xsl:template>

    <xsl:template name="getSpaceToScrollToFootnotesDiv">
        <xsl:if test="count(//cda:footnote) &gt; 0 or
                      (not($patientAge='DECEASED') and not($patientAge='AGE UNKNOWN') and string-length($patientCodedAge) = 0)">
                      <xsl:if test="not($cdaDocumentType='Advance Care Information')">                      
            <xsl:element name="div">
                <xsl:attribute name="class">spaceToScrollToFootnotesDiv</xsl:attribute>
                <xsl:attribute name="style">height:1500px; background:#FFFFFF; color:#FFFFFF;</xsl:attribute>
                <xsl:call-template name="printNBSPs"><xsl:with-param name="number">1</xsl:with-param></xsl:call-template>
            </xsl:element> <!-- </div> -->
            			</xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getStartOfDocumentIndicator">
        <xsl:call-template name="getDocumentIndicator">
            <xsl:with-param name="indicatorText">Start of document</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="getRenderingSpecificationIncompatibilityWarning">
        <xsl:call-template name="getDocumentIndicator">
            <xsl:with-param name="indicatorText"><xsl:value-of select="$CDA_RENDERING_SPECIFICATION_INCOMPATIBILITY_WARNING"/></xsl:with-param>
            <xsl:with-param name="paddingBottom">0</xsl:with-param>
            <xsl:with-param name="paddingTop">0</xsl:with-param>
            <xsl:with-param name="backgroundColour">FFFFFF</xsl:with-param>
            <xsl:with-param name="textColour">000000</xsl:with-param>
            <xsl:with-param name="borderColour">000000</xsl:with-param>
            <xsl:with-param name="fontSize">14</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="getAdministrativeDetailsIndicator">
        <xsl:call-template name="getDocumentIndicator">
            <xsl:with-param name="indicatorText">Administrative details</xsl:with-param>
            <xsl:with-param name="marginTop">10</xsl:with-param>
            <xsl:with-param name="marginBottom">10</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="getEndOfDocumentIndicator">
        <xsl:call-template name="getDocumentIndicator">
            <xsl:with-param name="indicatorText">End of document</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="getStyleSheetVersionIndicator">
        <xsl:call-template name="getDocumentIndicator">
            <xsl:with-param name="indicatorText" select="$VERSION_NOTE"/>
            <xsl:with-param name="backgroundColour">#FFFFFF</xsl:with-param>
            <xsl:with-param name="fontSize">8</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="getDocumentIndicator">
        <xsl:param name="indicatorText"/>
        <xsl:param name="marginTop"/>
        <xsl:param name="marginBottom"/>
        <xsl:param name="paddingTop"/>
        <xsl:param name="paddingBottom"/>
        <xsl:param name="backgroundColour"/>
        <xsl:param name="textColour"/>
        <xsl:param name="borderColour"/>
        <xsl:param name="fontSize"></xsl:param>
        
        <xsl:if test="$indicatorText and
                      string-length($indicatorText) &gt; 0">
            <xsl:element name="div">
                <xsl:if test="($indicatorText = 'Start of document') or ($indicatorText = 'Administrative details') or ($indicatorText = 'End of document')">
                    <xsl:if test="$indicatorText = 'Start of document'">
                        <xsl:attribute name="class">documentindicator documentindicatorcolours documentindicatorcolours-start</xsl:attribute>
                        <xsl:value-of select="$indicatorText"/>
                     </xsl:if>
                     <xsl:if test="$indicatorText = 'Administrative details'">
                        <xsl:attribute name="class">documentindicator documentindicatorcolours documentindicatorcolours-administrative</xsl:attribute>
                        <xsl:value-of select="$indicatorText"/>
                     </xsl:if>
                     <xsl:if test="$indicatorText = 'End of document'">
                        <xsl:attribute name="class">documentindicator documentindicatorcolours documentindicatorcolours-endofdocument</xsl:attribute>
                        <xsl:value-of select="$indicatorText"/>
                     </xsl:if>
                </xsl:if>
                <xsl:if test="($indicatorText != 'Start of document') and ($indicatorText != 'Administrative details') and ($indicatorText != 'End of document')">
                <xsl:choose>
                    <xsl:when test="(string-length($backgroundColour) &gt; 0) or (string-length($textColour) &gt; 0)">
                        <xsl:attribute name="class">documentindicator</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">documentindicator documentindicatorcolours</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="style">border: 0px SOLID #000000;
                    <xsl:choose>
                        <xsl:when test="$marginTop and string-length($marginTop) &gt; 0">margin-top: <xsl:value-of select="$marginTop"/>px;</xsl:when>
                        <xsl:otherwise>margin-top: 0px;</xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$marginBottom and string-length($marginBottom) &gt; 0">margin-bottom: <xsl:value-of select="$marginBottom"/>px;</xsl:when>
                        <xsl:otherwise>margin-bottom: 0px;</xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$paddingBottom and string-length($paddingBottom) &gt; 0">padding-bottom: <xsl:value-of select="$paddingBottom"/>px;</xsl:when>
                        <xsl:otherwise>padding-bottom: 0px;</xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="$paddingTop and string-length($paddingTop) &gt; 0">padding-top: <xsl:value-of select="$paddingTop"/>px;</xsl:when>
                        <xsl:otherwise>padding-top: 0px;</xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="string-length($backgroundColour) &gt; 0">background: #<xsl:value-of select="$backgroundColour"/>;</xsl:if>
                    <xsl:if test="string-length($textColour) &gt; 0">color: #<xsl:value-of select="$textColour"/>;</xsl:if>
                    <xsl:if test="string-length($fontSize) &gt; 0">font-size: <xsl:value-of select="$fontSize"/>px;</xsl:if>
                </xsl:attribute>                
                <xsl:choose>
                    <xsl:when test="string-length($borderColour) &gt; 0">
                        <xsl:element name="div">
                            <xsl:attribute name="style">padding: 0px; margin: 0px; border: 2px SOLID #<xsl:value-of select="$borderColour"/>;</xsl:attribute>
                            <xsl:value-of select="$indicatorText"/>
                        </xsl:element> <!-- </div> -->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$indicatorText"/>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:if>
            </xsl:element> <!-- </div> -->
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getAddressDetailsRows">
        <xsl:param name="personOrOrg"/>
        <xsl:param name="IsPerson"/>
        <xsl:choose>
            <xsl:when test="count($personOrOrg/cda:addr) &gt; 0">
                <xsl:for-each select="$personOrOrg/cda:addr">
                    <xsl:if test="$IsPerson='yes' or ./@use ='WP'">
                        <xsl:element name="tr">
                            <xsl:element name="th">
                                <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                                <xsl:element name="span">
                                    <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                    <xsl:choose>
                                        <xsl:when test="./@nullFlavor='NA'">
                                            Address
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="getAddressUseDescriptor">
                                                <xsl:with-param name="code" select="./@use"></xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element> 
                            <xsl:element name="td">
                                <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                                <xsl:call-template name="show-address">
                                    <xsl:with-param name="address" select="."/>
                                </xsl:call-template>
                            </xsl:element> <!-- </td> --> 
                        </xsl:element> <!-- </tr> -->
                    </xsl:if>
                </xsl:for-each>                    
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="tr">
                    <xsl:element name="th">
                        <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                        <xsl:element name="span">
                            <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                            Address
                        </xsl:element> <!-- </tspan> -->
                    </xsl:element>  <!-- </th> -->
                    <xsl:element name="td">
                        Not Provided
                    </xsl:element> <!-- </td> --> 
                </xsl:element> <!-- </tr> -->                
            </xsl:otherwise>            
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="getContactDetailsRows">
        <xsl:param name="personOrOrg"/>
        <xsl:param name="IsPerson"/>
        <xsl:if test="count($personOrOrg/cda:telecom[starts-with(@value, 'tel:') or starts-with(@value, 'fax:') or starts-with(@value, 'mailto:')]) &gt; 0">
            <xsl:for-each select="$personOrOrg/cda:telecom[starts-with(@value, 'tel:')]">
                <xsl:if test="./@use = 'WP' or $IsPerson = 'yes'">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="position()=1">Phone <xsl:if test="count($personOrOrg/cda:telecom[starts-with(@value, 'tel:')]) &gt; 1">1</xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>Phone 2</xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element> 
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:call-template name="show-telecom">
                                <xsl:with-param name="telecom" select="."/>
                                <xsl:with-param name="IsPerson" select="$IsPerson"/>
                            </xsl:call-template>
                        </xsl:element> 
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$personOrOrg/cda:telecom[starts-with(@value, 'fax:')]">
                <xsl:if test="./@use = 'WP' or $IsPerson = 'yes'">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="position()=1">FAX</xsl:when>
                                    <xsl:otherwise>FAX</xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element> 
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:call-template name="show-telecom">
                                <xsl:with-param name="telecom" select="."/>
                                <xsl:with-param name="IsPerson" select="$IsPerson"/>
                            </xsl:call-template>
                        </xsl:element> 
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$personOrOrg/cda:telecom[starts-with(@value, 'mailto:')]">
                <xsl:if test="./@use = 'WP' or $IsPerson = 'yes'">
                    <xsl:element name="tr">
                        <xsl:element name="th">
                            <xsl:attribute name="class">detailsHalfTableTh</xsl:attribute>
                            <xsl:element name="span">
                                <xsl:attribute name="class">detailsHalfTableThSpan</xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="position()=1">Email</xsl:when>
                                    <xsl:otherwise>Email</xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element> 
                        <xsl:element name="td">
                            <xsl:attribute name="class">detailsHalfTableTd</xsl:attribute>
                            <xsl:call-template name="show-telecom">
                                <xsl:with-param name="telecom" select="."/>
                                <xsl:with-param name="IsPerson" select="$IsPerson"/>
                            </xsl:call-template>
                        </xsl:element> 
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>            
        </xsl:if>
    </xsl:template>
        
    <xsl:template name="getContactDetails">
        <xsl:param name="personOrOrg"/>
        <xsl:choose>
            <xsl:when test="count($personOrOrg/cda:telecom[starts-with(@value, 'tel:') or starts-with(@value, 'fax:') or starts-with(@value, 'mailto:')]) &gt; 0">
                
                <xsl:element name="dl">
                    <xsl:attribute name="class">contactdetailsdl</xsl:attribute>
                    
                    <xsl:if test="count($personOrOrg/cda:telecom[starts-with(@value, 'tel:')]) &gt; 0">
                        <xsl:element name="dt">
                            <xsl:attribute name="class">contactdetailsdt</xsl:attribute>
                            Phone:
                        </xsl:element>
                        <xsl:element name="dd">
                            <xsl:attribute name="class">contactdetailsdd</xsl:attribute>
                            <xsl:element name="ul">
                                <xsl:attribute name="class">contactdetailsul</xsl:attribute>                                        
                                <xsl:for-each select="$personOrOrg/cda:telecom[starts-with(@value, 'tel:')]">
                                    <xsl:element name="li">
                                        <xsl:call-template name="show-telecom">
                                            <xsl:with-param name="telecom" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element> <!-- </dd> -->
                    </xsl:if>
                    
                    <xsl:if test="count($personOrOrg/cda:telecom[starts-with(@value, 'fax:')]) &gt; 0">
                        <xsl:element name="dt">
                            <xsl:attribute name="class">contactdetailsdt</xsl:attribute>
                            Facsimile machine:
                        </xsl:element>
                        <xsl:element name="dd">
                            <xsl:attribute name="class">contactdetailsdd</xsl:attribute>
                            <xsl:element name="ul">
                                <xsl:attribute name="class">contactdetailsul</xsl:attribute>                                        
                                <xsl:for-each select="$personOrOrg/cda:telecom[starts-with(@value, 'fax:')]">                                            
                                    <xsl:element name="li">
                                        <xsl:call-template name="show-telecom">
                                            <xsl:with-param name="telecom" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element> <!-- </dd> -->
                    </xsl:if>
                    
                    <xsl:if test="count($personOrOrg/cda:telecom[starts-with(@value, 'mailto:')]) &gt; 0">
                        <xsl:element name="dt">
                            <xsl:attribute name="class">contactdetailsdt</xsl:attribute>
                            Email:
                        </xsl:element>
                        <xsl:element name="dd">
                            <xsl:attribute name="class">contactdetailsdd</xsl:attribute>
                            <xsl:element name="ul">
                                <xsl:attribute name="class">contactdetailsul</xsl:attribute>
                                <xsl:for-each select="$personOrOrg/cda:telecom[starts-with(@value, 'mailto:')]">
                                    <xsl:element name="li">                                        
                                        <xsl:call-template name="show-telecom">
                                            <xsl:with-param name="telecom" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element> <!-- </dd> -->
                    </xsl:if>                                
                </xsl:element> <!-- </dl> -->
            </xsl:when>
            <xsl:otherwise>Not Provided</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--================================================================================================================================================================================-->
    <!-- [END] STRUCTURE TEMPLATES -->




    <!-- UTILITY TEMPLATES -->    
    <!--================================================================================================================================================================================-->
    
    <xsl:template name="ucumUnitCodeToUnitName">
        <xsl:param name="ucumUnit"/>
        <xsl:param name="defaultName"/>
        
        <xsl:choose>
            <xsl:when test="$ucumUnit = 'a'">
                <xsl:text> years</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'mo'">
                <xsl:text> months</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'wk'">
                <xsl:text> weeks</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'd'">
                <xsl:text> days</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'h'">
                <xsl:text> hours</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'min'">
                <xsl:text> minutes</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 's'">
                <xsl:text> seconds</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$defaultName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="ucumUnitCodeToUnitNameShortForm">
        <xsl:param name="ucumUnit"/>
        <xsl:param name="defaultName"/>
        
        <xsl:choose>
            <xsl:when test="$ucumUnit = 'a'">
                <xsl:text> years</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'mo'">
                <xsl:text>m</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'wk'">
                <xsl:text>w</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'd'">
                <xsl:text>d</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'h'">
                <xsl:text>h</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 'min'">
                <xsl:text>min</xsl:text>
            </xsl:when>
            <xsl:when test="$ucumUnit = 's'">
                <xsl:text>s</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$defaultName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="show-name">
        <xsl:param name="name"/>
        
        <xsl:call-template name="trim">
            <xsl:with-param name="string">
                <xsl:choose>
                    <xsl:when test="$name/cda:family">
                        <xsl:for-each select="$name/cda:prefix">
                            <xsl:if test="string-length(./text()) &gt; 0">
                                <xsl:value-of select="./text()"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="$name/cda:given">
                            <xsl:if test="string-length(./text()) &gt; 0">
                                <xsl:value-of select="./text()"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
        
                        <xsl:for-each select="$name/cda:family">
                            <xsl:if test="string-length(./text()) &gt; 0">
                                <xsl:value-of select="./text()"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
        
                        <xsl:for-each select="$name/cda:suffix">
                            <xsl:if test="string-length(./text()) &gt; 0">
                                <xsl:value-of select="./text()"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
   
    <xsl:template name="show-patient-name">
        <xsl:param name="name"/>
        
        <xsl:call-template name="trim">
            <xsl:with-param name="string">
                <xsl:choose>
                    <xsl:when test="$name/cda:family">
                        <xsl:for-each select="$name/cda:prefix">
                            <xsl:if test="string-length(./text()) &gt; 0">
                                <xsl:value-of select="./text()"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="$name/cda:given">
                            <xsl:if test="string-length(./text()) &gt; 0">
                                <xsl:value-of select="./text()"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        
                        <xsl:for-each select="$name/cda:family">
                            <xsl:if test="string-length(./text()) &gt; 0">
                                <xsl:call-template name="toUpperCase">
                                    <xsl:with-param name="data">
                                        <xsl:value-of select="./text()"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        
                        <xsl:for-each select="$name/cda:suffix">
                            <xsl:if test="string-length(./text()) &gt; 0">
                                <xsl:value-of select="./text()"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
   
    <xsl:template name="getAddress">
        <xsl:param name="address"/>
        <xsl:if test="$address">
            <xsl:choose>
                <xsl:when test="$address/@nullFlavor='NA'">
                    <xsl:element name="dt"><xsl:attribute name="class">addressdt</xsl:attribute>No Fixed Address</xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="dt"><xsl:attribute name="class">addressdt</xsl:attribute><xsl:call-template name="getAddressUseDescriptor"><xsl:with-param name="code" select="./@use"/></xsl:call-template><xsl:text>:</xsl:text><xsl:element name="br"/></xsl:element>
                    <xsl:element name="dd"><xsl:attribute name="class">addressdd</xsl:attribute>
                        <xsl:if test="$address/cda:streetAddressLine">
                            <xsl:for-each select="$address/cda:streetAddressLine[string-length(text()) &gt; 0]">
                                <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
                                <xsl:value-of select="."/>
                            </xsl:for-each>
                            <xsl:if test="($address/cda:houseNumber and
                                           string-length($address/cda:houseNumber) &gt; 0) or
                                          ($address/cda:streetName and
                                           string-length($address/cda:streetName) &gt; 0) or
                                           ($address/cda:streetNameType and
                                           string-length($address/cda:streetNameType) &gt; 0) or
                                           ($address/cda:city and
                                           string-length($address/cda:city) &gt; 0) or
                                          ($address/cda:state and
                                           string-length($address/cda:state) &gt; 0) or
                                          ($address/cda:postalCode and
                                           string-length($address/cda:postalCode) &gt; 0) or
                                          ($address/cda:country and
                                           string-length($address/cda:country) &gt; 0)">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:if>

                        <xsl:if test="$address/cda:houseNumber and string-length($address/cda:houseNumber) &gt; 0">
                            <xsl:value-of select="$address/cda:houseNumber"/>
                            <xsl:choose>
                                <xsl:when test="$address/cda:streetName and string-length($address/cda:streetName) &gt; 0">
                                    <xsl:text> </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="($address/cda:city and
                                                   string-length($address/cda:city) &gt; 0) or
                                                  ($address/cda:state and
                                                   string-length($address/cda:state) &gt; 0) or
                                                  ($address/cda:postalCode and
                                                  string-length($address/cda:postalCode) &gt; 0) or
                                                  ($address/cda:country and
                                                   string-length($address/cda:country) &gt; 0)">
                                                   <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$address/cda:streetName and string-length($address/cda:streetName) &gt; 0">
                            <xsl:value-of select="$address/cda:streetName"/>
                            <xsl:choose>
                                <xsl:when test="$address/cda:streetNameType and string-length($address/cda:streetNameType) &gt; 0">
                                    <xsl:text> </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="($address/cda:city and
                                               string-length($address/cda:city) &gt; 0) or
                                              ($address/cda:state and
                                               string-length($address/cda:state) &gt; 0) or
                                              ($address/cda:postalCode and
                                               string-length($address/cda:postalCode) &gt; 0) or
                                              ($address/cda:country and
                                               string-length($address/cda:country) &gt; 0)">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="$address/cda:streetNameType and string-length($address/cda:streetNameType) &gt; 0">
                                <xsl:value-of select="$address/cda:streetNameType"/>
                                <xsl:if test="($address/cda:city and
                                               string-length($address/cda:city) &gt; 0) or
                                               ($address/cda:state and
                                               string-length($address/cda:state) &gt; 0) or
                                               ($address/cda:postalCode and
                                               string-length($address/cda:postalCode) &gt; 0) or
                                               ($address/cda:country and
                                               string-length($address/cda:country) &gt; 0)">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="string-length($address/cda:city)>0">
                            <xsl:value-of select="$address/cda:city"/>
                            <xsl:if test="($address/cda:state and
                                           string-length($address/cda:state) &gt; 0) or
                                          ($address/cda:postalCode and
                                           string-length($address/cda:postalCode) &gt; 0) or
                                          ($address/cda:country and
                                           string-length($address/cda:country) &gt; 0)">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="string-length($address/cda:state)>0">
                            <xsl:value-of select="$address/cda:state"/>
                            <xsl:if test="($address/cda:postalCode and
                                           string-length($address/cda:postalCode) &gt; 0) or
                                          ($address/cda:country and
                                           string-length($address/cda:country) &gt; 0)">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="string-length($address/cda:postalCode)>0">
                            <xsl:value-of select="$address/cda:postalCode"/>
                            <xsl:if test="($address/cda:country and
                                           string-length($address/cda:country) &gt; 0)">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:if>
                        <xsl:if test="string-length($address/cda:country)>0">
                            <xsl:value-of select="$address/cda:country"/>
                        </xsl:if>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
    </xsl:template>

    <xsl:template name="show-address">
        <xsl:param name="address"/>
        <xsl:if test="$address">
            <xsl:choose>
                <xsl:when test="$address/@nullFlavor='NA'">
                    No Fixed Address
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$address/cda:unitID and string-length($address/cda:unitID)>0">
                        <xsl:value-of select="concat('Unit Number: ', $address/cda:unitID)"/>
                        <xsl:element name="br"/>
                    </xsl:if>
                    <xsl:if test="$address/cda:unitType and string-length($address/cda:unitType)>0">
                        <xsl:value-of select="concat('Unit Type: ', $address/cda:unitType)"/>
                        <xsl:element name="br"/>
                    </xsl:if>
                    <xsl:if test="$address/cda:deliveryAddressLine and string-length($address/cda:deliveryAddressLine)>0">
                        <xsl:for-each select="$address/cda:deliveryAddressLine">
                            <xsl:if test="string-length(./text())>0">
                                <xsl:choose>
                                    <xsl:when test="./text()='Care PO'">
                                        <xsl:text>Postal Delivery Type: Care-of Post Office / Poste Restante</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='CMA'">
                                        <xsl:text>Postal Delivery Type: Community Mail Agent</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='CMB'">
                                        <xsl:text>Postal Delivery Type: Community Mail Bag</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='GPO'">
                                        <xsl:text>Postal Delivery Type: Box General Post Office Box</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='Locked Bag'">
                                        <xsl:text>Postal Delivery Type: Locked Mail Bag Service</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='PO Box'">
                                        <xsl:text>Postal Delivery Type: Post Office Box</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='MS'">
                                        <xsl:text>Postal Delivery Type: Mail Service</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='Private Bag'">
                                        <xsl:text>Postal Delivery Type: Private Mail Bag Service</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='RSD'">
                                        <xsl:text>Postal Delivery Type: Roadside Delivery</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='RMB'">
                                        <xsl:text>Postal Delivery Type: Roadside Mail Box/Bag</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:when test="./text()='RMS'">
                                        <xsl:text>Postal Delivery Type: Roadside Mail Service</xsl:text>
                                        <xsl:element name="br"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('Postal Delivery Number: ', ./text())"/>
                                        <xsl:element name="br"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$address/cda:streetAddressLine">
                        <xsl:for-each select="$address/cda:streetAddressLine[string-length(text()) &gt; 0]">
                            <xsl:if test="position() &gt; 1"><xsl:text>, </xsl:text></xsl:if>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:if test="($address/cda:houseNumber and
                            string-length($address/cda:houseNumber) &gt; 0) or
                            ($address/cda:streetName and
                            string-length($address/cda:streetName) &gt; 0) or
                            ($address/cda:streetNameType and
                            string-length($address/cda:streetNameType) &gt; 0) or
                            ($address/cda:direction and
                            string-length($address/cda:direction) &gt; 0) or
                            ($address/cda:city and
                            string-length($address/cda:city) &gt; 0) or
                            ($address/cda:state and
                            string-length($address/cda:state) &gt; 0) or
                            ($address/cda:postalCode and
                            string-length($address/cda:postalCode) &gt; 0) or
                            ($address/cda:country and
                            string-length($address/cda:country) &gt; 0)">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="$address/cda:houseNumber and string-length($address/cda:houseNumber) &gt; 0">
                        <xsl:value-of select="$address/cda:houseNumber"/>
                        <xsl:choose>
                            <xsl:when test="$address/cda:streetName and string-length($address/cda:streetName) &gt; 0">
                                <xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="($address/cda:direction and
                                    string-length($address/cda:direction) &gt; 0) or
                                    ($address/cda:city and
                                    string-length($address/cda:city) &gt; 0) or
                                    ($address/cda:state and
                                    string-length($address/cda:state) &gt; 0) or
                                    ($address/cda:postalCode and
                                    string-length($address/cda:postalCode) &gt; 0) or
                                    ($address/cda:country and
                                    string-length($address/cda:country) &gt; 0)">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="$address/cda:streetName and string-length($address/cda:streetName) &gt; 0">
                        <xsl:value-of select="$address/cda:streetName"/>
                        <xsl:choose>
                            <xsl:when test="$address/cda:streetNameType and string-length($address/cda:streetNameType) &gt; 0">
                                <xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="($address/cda:direction and
                                    string-length($address/cda:direction) &gt; 0) or
                                    ($address/cda:city and
                                    string-length($address/cda:city) &gt; 0) or
                                    ($address/cda:state and
                                    string-length($address/cda:state) &gt; 0) or
                                    ($address/cda:postalCode and
                                    string-length($address/cda:postalCode) &gt; 0) or
                                    ($address/cda:country and
                                    string-length($address/cda:country) &gt; 0)">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$address/cda:streetNameType and string-length($address/cda:streetNameType) &gt; 0">
                            <xsl:value-of select="$address/cda:streetNameType"/>
                            <xsl:choose>
                                <xsl:when test="$address/cda:direction and string-length($address/cda:direction) &gt; 0">
                                    <xsl:text> </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="($address/cda:city and
                                        string-length($address/cda:city) &gt; 0) or
                                        ($address/cda:state and
                                        string-length($address/cda:state) &gt; 0) or
                                        ($address/cda:postalCode and
                                        string-length($address/cda:postalCode) &gt; 0) or
                                        ($address/cda:country and
                                        string-length($address/cda:country) &gt; 0)">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="$address/cda:direction and string-length($address/cda:direction) &gt; 0">
                            <xsl:value-of select="$address/cda:direction"/>
                            <xsl:if test="($address/cda:city and
                                string-length($address/cda:city) &gt; 0) or
                                ($address/cda:state and
                                string-length($address/cda:state) &gt; 0) or
                                ($address/cda:postalCode and
                                string-length($address/cda:postalCode) &gt; 0) or
                                ($address/cda:country and
                                string-length($address/cda:country) &gt; 0)">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="string-length($address/cda:city)>0">
                        <xsl:value-of select="$address/cda:city"/>
                        <xsl:if test="($address/cda:state and
                            string-length($address/cda:state) &gt; 0) or
                            ($address/cda:postalCode and
                            string-length($address/cda:postalCode) &gt; 0) or
                            ($address/cda:country and
                            string-length($address/cda:country) &gt; 0)">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="string-length($address/cda:state)>0">
                        <xsl:value-of select="$address/cda:state"/>
                        <xsl:if test="($address/cda:postalCode and
                            string-length($address/cda:postalCode) &gt; 0) or
                            ($address/cda:country and
                            string-length($address/cda:country) &gt; 0)">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="string-length($address/cda:postalCode)>0">
                        <xsl:value-of select="$address/cda:postalCode"/>
                        <xsl:if test="($address/cda:country and
                            string-length($address/cda:country) &gt; 0)">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="string-length($address/cda:country)>0">
                        <xsl:value-of select="$address/cda:country"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="show-telecom">
        <xsl:param name="telecom"/>
        <xsl:param name="IsPerson"/>
        <xsl:if test="$telecom and string-length($telecom/@value) &gt; 0 and ($telecom/@use='WP' or $IsPerson)">
            <xsl:choose>
                <xsl:when test="contains($telecom/@value, ':')">
                    <xsl:variable name="value" select="substring-after($telecom/@value, ':')"/>
                        <xsl:if test="$value">
                            <xsl:value-of select="$value"/>
                        </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$telecom/@value"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="string-length(./@use) &gt; 0"><xsl:text> </xsl:text>(<xsl:call-template name="getTelecomUseDescriptors"><xsl:with-param name="codes" select="./@use"/></xsl:call-template>)</xsl:if>
        </xsl:if>
    </xsl:template>
  
    <xsl:template name="getTelecomUseDescriptors">
        <xsl:param name="codes" />
        
        <xsl:variable name="newlist" select="concat(normalize-space($codes), ' ')" /> 
        <xsl:variable name="first" select="substring-before($newlist, ' ')" /> 
        <xsl:variable name="remaining" select="substring-after($newlist, ' ')" /> 
        <xsl:call-template name="getTelecomUseDescriptor">
            <xsl:with-param name="code"><xsl:value-of select="$first"/></xsl:with-param>
        </xsl:call-template> 
        <xsl:if test="$remaining">
            <xsl:text>, </xsl:text>
            <xsl:call-template name="getTelecomUseDescriptors">
                <xsl:with-param name="codes" select="$remaining" /> 
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getTelecomUseDescriptor">
        <xsl:param name="code"/>
        <xsl:choose>
            <xsl:when test="$code='H'">
                <xsl:text>Home</xsl:text>
            </xsl:when>
            <xsl:when test="$code='HP'">
                <xsl:text>Primary Home</xsl:text>
            </xsl:when>
            <xsl:when test="$code='HV'">
                <xsl:text>Vacation Home</xsl:text>
            </xsl:when>
            <xsl:when test="$code='WP'">
                <xsl:text>Workplace</xsl:text>
            </xsl:when>
            <xsl:when test="$code='AS'">
                <xsl:text>Answering Service</xsl:text>
            </xsl:when>
            <xsl:when test="$code='EC'">
                <xsl:text>Emergency Contact</xsl:text>
            </xsl:when>
            <xsl:when test="$code='MC'">
                <xsl:text>Mobile Contact</xsl:text>
            </xsl:when>
            <xsl:when test="$code='PG'">
                <xsl:text>PG Pager</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Unknown Usage</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getAddressUseDescriptor">
        <xsl:param name="code"/>
        <xsl:choose>
            <xsl:when test="$code='WP'">
                <xsl:text>Work Place</xsl:text>
            </xsl:when>
            <xsl:when test="$code='PST'">
                <xsl:text>Postal Address</xsl:text>
            </xsl:when>
            <xsl:when test="$code='TMP'">
                <xsl:text>Temporary Address</xsl:text>
            </xsl:when>
            <xsl:when test="$code='H'">
                <xsl:text>Home Address</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Address</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="show-date">
        <xsl:param name="datetime"/>       
        <xsl:call-template name="trim">
            <xsl:with-param name="string">    
                <xsl:choose>
                    <xsl:when test="not($datetime)">
                        <xsl:call-template name="formatDate">
                            <xsl:with-param name="date" select="@value"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="formatDate">
                            <xsl:with-param name="date" select="$datetime/@value"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="show-time">
        <xsl:param name="datetime"/>
        
        <xsl:call-template name="trim">
            <xsl:with-param name="string">    
                <xsl:choose>
                    <xsl:when test="not($datetime)">
                        <xsl:call-template name="formatDateTime">
                            <xsl:with-param name="date" select="@value"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="formatDateTime">
                           <xsl:with-param name="date" select="$datetime/@value"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="formatDateTime">
        <xsl:param name="date"/>
        
        <!-- day -->
        <xsl:choose>
            <xsl:when test="substring ($date, 7, 1)='0'">
                <xsl:choose>
                    <xsl:when test="substring ($date, 8, 1)='1'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>st </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='2'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>nd </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='3'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>rd </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='4'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='5'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='6'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='7'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='8'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='9'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="string-length(substring ($date, 7, 1)) &gt; 0">
                <xsl:choose>
                    <xsl:when test="substring ($date, 8, 1)='1'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>st </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='2'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>nd </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='3'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>rd </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='4'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='5'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='6'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='7'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='8'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='9'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='0'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <!-- month -->
        <xsl:variable name="month" select="substring ($date, 5, 2)"/>
        <xsl:choose>
            <xsl:when test="$month='01'">
                <xsl:text>January</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='02'">
                <xsl:text>February</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='03'">
                <xsl:text>March</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='04'">
                <xsl:text>April</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='05'">
                <xsl:text>May</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='06'">
                <xsl:text>June</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='07'">
                <xsl:text>July</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='08'">
                <xsl:text>August</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='09'">
                <xsl:text>September</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='10'">
                <xsl:text>October</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='11'">
                <xsl:text>November</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='12'">
                <xsl:text>December</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
        </xsl:choose>
        <!-- year -->
        <xsl:value-of select="substring ($date, 1, 4)"/>
        <!-- time -->
        <xsl:if test="string-length($date) > 8">
            <xsl:text> </xsl:text>
            <xsl:variable name="time">
                <xsl:value-of select="substring($date,9,6)"/>
            </xsl:variable>
            <xsl:variable name="hh">
                <xsl:value-of select="substring($time,1,2)"/>
            </xsl:variable>
            <xsl:variable name="mm">
                <xsl:value-of select="substring($time,3,2)"/>
            </xsl:variable>
            <xsl:variable name="ss">
                <xsl:value-of select="substring($time,5,2)"/>
            </xsl:variable>
            <xsl:if test="string-length($hh)&gt;1">
                <xsl:value-of select="$hh"/>
                <xsl:if
                    test="string-length($mm)&gt;1 and not(contains($mm,'-')) and not (contains($mm,'+'))">
                    <xsl:text>:</xsl:text>
                    <xsl:value-of select="$mm"/>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <!-- time zone -->
        <!--<xsl:if test="(contains($date,'+') and string-length(substring-after($date,'+')) = 4) or
                      (contains($date,'-') and string-length(substring-after($date,'-')) = 4)">
            <xsl:variable name="tzon">
                <xsl:choose>
                    <xsl:when test="contains($date,'+')">
                        <xsl:text>+</xsl:text>
                        <xsl:value-of select="substring-after($date, '+')"/>
                    </xsl:when>
                    <xsl:when test="contains($date,'-')">
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="substring-after($date, '-')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="string-length($tzon) &gt; 0">
                <xsl:value-of select="$tzon"/>
            </xsl:if>
        </xsl:if>-->
    </xsl:template>

    <xsl:template name="formatDate">
        <xsl:param name="date"/>
        
        <!-- day -->
        <xsl:choose>
            <xsl:when test="substring ($date, 7, 1)='0'">
                <xsl:choose>
                    <xsl:when test="substring ($date, 8, 1)='1'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>st </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='2'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>nd </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='3'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>rd </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='4'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='5'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='6'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='7'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='8'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='9'"><xsl:value-of select="substring ($date, 8, 1)"/><xsl:text>th </xsl:text></xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="string-length(substring ($date, 7, 1)) &gt; 0">
                <xsl:choose>
                    <xsl:when test="substring ($date, 8, 1)='1'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>st </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='2'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>nd </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='3'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>rd </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='4'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='5'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='6'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='7'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='8'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='9'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                    <xsl:when test="substring ($date, 8, 1)='0'"><xsl:value-of select="substring ($date, 7, 2)"/><xsl:text>th </xsl:text></xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <!-- month -->
        <xsl:variable name="month" select="substring ($date, 5, 2)"/>
        <xsl:choose>
            <xsl:when test="$month='01'">
                <xsl:text>January</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='02'">
                <xsl:text>February</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='03'">
                <xsl:text>March</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='04'">
                <xsl:text>April</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='05'">
                <xsl:text>May</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='06'">
                <xsl:text>June</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='07'">
                <xsl:text>July</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='08'">
                <xsl:text>August</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='09'">
                <xsl:text>September</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='10'">
                <xsl:text>October</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='11'">
                <xsl:text>November</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$month='12'">
                <xsl:text>December</xsl:text><xsl:text> </xsl:text>
            </xsl:when>
        </xsl:choose>
        <!-- year -->
        <xsl:value-of select="substring ($date, 1, 4)"/>
    </xsl:template>
    
    <xsl:template name="getProviderIndividualIdentifier">
        <xsl:param name="entityIdentifier"/>
        <xsl:if test="$providerIndividualIdentifierDisplay='true' and
                      $entityIdentifier and
                      $entityIdentifier/@classCode and
                      $entityIdentifier/@classCode='IDENT' and
                      $entityIdentifier/ext:id and
                      not($entityIdentifier/ext:id/@displayble='false') and
                      $entityIdentifier/ext:id/@root and
                      string-length($entityIdentifier/ext:id/@root) &gt; 0">
            <xsl:choose>
                <!-- HI Service: HPI-I -->
                <xsl:when test="starts-with($entityIdentifier/ext:id/@root, '1.2.36.1.2001.1003.0.') and
                                $entityIdentifier/ext:id/@assigningAuthorityName='HPI-I' and
                                $entityIdentifier/ext:assigningGeographicArea/@classCode='PLC' and
                                $entityIdentifier/ext:assigningGeographicArea/ext:name='National Identifier'">
                    <xsl:variable name="identifier">
                        <xsl:value-of select="substring-after($entityIdentifier/ext:id/@root, '1.2.36.1.2001.1003.0.')"/>
                    </xsl:variable>
                    <xsl:element name="div">
                        <xsl:attribute name="class"><xsl:value-of select="$PROVIDER_INDIVIDUAL_IDENTIFIER_CSS_CLASS"/></xsl:attribute>
                        <xsl:text>[HPI-I: </xsl:text><xsl:call-template name="formatHI"><xsl:with-param name="hiValue"><xsl:value-of select="$identifier"/></xsl:with-param></xsl:call-template><xsl:text>]</xsl:text>
                    </xsl:element>
                </xsl:when>
                <!-- Identifiers Other than HI Service e.g. MRN, Medicare Provider Number, etc. -->
                <xsl:otherwise>
                    <xsl:call-template name="getNonHIServiceProviderIdentifierDiv">
                        <xsl:with-param name="entityIdentifier" select="$entityIdentifier"/>
                        <xsl:with-param name="providerIdentifierType"><xsl:value-of select="$PROVIDER_INDIVIDUAL_IDENTIFIER_CSS_CLASS"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getProviderDeviceIdentifier">
        <xsl:param name="entityIdentifier"/>
        <xsl:if test="$providerDeviceIdentifierDisplay='true' and
                      $entityIdentifier and
                      $entityIdentifier/@classCode and
                      $entityIdentifier/@classCode='IDENT' and
                      $entityIdentifier/ext:id and
                      not($entityIdentifier/ext:id/@displayble='false') and
                      $entityIdentifier/ext:id/@root and
                      string-length($entityIdentifier/ext:id/@root) &gt; 0">
                <!-- PCEHR: PAI-D -->
                <xsl:if test="starts-with($entityIdentifier/ext:id/@root, '1.2.36.1.2001.1007.20.') and
                    $entityIdentifier/ext:id/@assigningAuthorityName='PAI-D'">
                    <xsl:variable name="identifier">
                        <xsl:value-of select="substring-after($entityIdentifier/ext:id/@root, '1.2.36.1.2001.1007.20.')"/>
                    </xsl:variable>
                    <xsl:element name="div">
                        <xsl:attribute name="class"><xsl:value-of select="$PROVIDER_DEVICE_IDENTIFIER_CSS_CLASS"/></xsl:attribute>
                        <xsl:text>[PAI-D: </xsl:text><xsl:call-template name="formatHI"><xsl:with-param name="hiValue"><xsl:value-of select="$identifier"/></xsl:with-param></xsl:call-template><xsl:text>]</xsl:text>
                    </xsl:element>
                </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getProviderOrganisationIdentifier">
        <xsl:param name="entityIdentifier"/>
        
        <xsl:if test="$providerOrganisationIdentifierDisplay='true' and
                      $entityIdentifier and
                      $entityIdentifier/@classCode and
                      $entityIdentifier/@classCode='IDENT' and
                      $entityIdentifier/ext:id and
                      not($entityIdentifier/ext:id/@displayble='false') and
                      $entityIdentifier/ext:id/@root and
                      string-length($entityIdentifier/ext:id/@root) &gt; 0">
            <xsl:choose>
                <!-- HI Service: HPI-O -->
                <xsl:when test="starts-with($entityIdentifier/ext:id/@root, '1.2.36.1.2001.1003.0.') and
                    $entityIdentifier/ext:id/@assigningAuthorityName='HPI-O' and
                    $entityIdentifier/ext:assigningGeographicArea/@classCode='PLC' and
                    $entityIdentifier/ext:assigningGeographicArea/ext:name='National Identifier'">
                    <xsl:variable name="identifier">
                        <xsl:value-of select="substring-after($entityIdentifier/ext:id/@root, '1.2.36.1.2001.1003.0.')"/>
                    </xsl:variable>
                    <xsl:element name="div">
                        <xsl:attribute name="class"><xsl:value-of select="$PROVIDER_ORGANISATION_IDENTIFIER_CSS_CLASS"/></xsl:attribute>
                        <xsl:text>[HPI-O: </xsl:text><xsl:call-template name="formatHI"><xsl:with-param name="hiValue"><xsl:value-of select="$identifier"/></xsl:with-param></xsl:call-template><xsl:text>]</xsl:text>
                    </xsl:element>
                </xsl:when>
                <!-- PCEHR: PAI-O -->
                <xsl:when test="starts-with($entityIdentifier/ext:id/@root, '1.2.36.1.2001.1007.1.') and
                    $entityIdentifier/ext:id/@assigningAuthorityName='PAI-O'">
                    <xsl:variable name="identifier">
                        <xsl:value-of select="substring-after($entityIdentifier/ext:id/@root, '1.2.36.1.2001.1007.1.')"/>
                    </xsl:variable>
                    <xsl:element name="div">
                        <xsl:attribute name="class"><xsl:value-of select="$PROVIDER_ORGANISATION_IDENTIFIER_CSS_CLASS"/></xsl:attribute>
                        <xsl:text>[PAI-O: </xsl:text><xsl:call-template name="formatHI"><xsl:with-param name="hiValue"><xsl:value-of select="$identifier"/></xsl:with-param></xsl:call-template><xsl:text>]</xsl:text>
                    </xsl:element>
                </xsl:when>
                <!-- Identifiers Other than HI Service e.g. Facility Identifier etc. -->
                <xsl:otherwise>
                    <xsl:call-template name="getNonHIServiceProviderIdentifierDiv">
                        <xsl:with-param name="entityIdentifier" select="$entityIdentifier"/>
                        <xsl:with-param name="providerIdentifierType"><xsl:value-of select="$PROVIDER_ORGANISATION_IDENTIFIER_CSS_CLASS"/></xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getNonHIServiceProviderIdentifierDiv">
        <xsl:param name="entityIdentifier"/>
        <xsl:param name="providerIdentifierType"/>
        
        <xsl:if test="$entityIdentifier/ext:code and
            $entityIdentifier/ext:code/@code and
            string-length($entityIdentifier/ext:code/@code) &gt; 0 and
            $entityIdentifier/ext:code/@codeSystem and
            $entityIdentifier/ext:code/@codeSystem='2.16.840.1.113883.12.203'">
            <xsl:variable name="identifier">
                <xsl:choose>
                    <xsl:when test="$entityIdentifier/ext:id/@extension and
                        string-length($entityIdentifier/ext:id/@extension) &gt; 0">
                        <xsl:value-of select="$entityIdentifier/ext:id/@extension"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="substring-after-last-occurance">
                            <xsl:with-param name="string" select="$entityIdentifier/ext:id/@root"/>
                            <xsl:with-param name="argument">.</xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="identifierType">
                <xsl:call-template name="getHL7V2Table0203IdentifierCodeDescription">
                    <xsl:with-param name="code" select="$entityIdentifier/ext:code/@code"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="identifierAssigningAuthorityName">
                <xsl:if test="$entityIdentifier/ext:id/@assigningAuthorityName and
                    string-length($entityIdentifier/ext:id/@assigningAuthorityName) &gt; 0">
                    <xsl:value-of select="$entityIdentifier/ext:id/@assigningAuthorityName"/>
                </xsl:if>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$identifierAssigningAuthorityName and 
                    string-length($identifierAssigningAuthorityName) &gt; 0">
                    <xsl:element name="div">
                        <xsl:attribute name="class"><xsl:value-of select="$providerIdentifierType"/></xsl:attribute>
                        <xsl:text>[</xsl:text><xsl:value-of select="$identifierAssigningAuthorityName"/><xsl:text>: </xsl:text>    
                        <xsl:value-of select="$identifier"/>
                        <xsl:text>]</xsl:text>
                    </xsl:element> <!-- </div> -->
                    
                </xsl:when>
                <xsl:when test="$identifierType and 
                    string-length($identifierType) &gt; 0">
                    <xsl:element name="div">
                        <xsl:attribute name="class"><xsl:value-of select="$providerIdentifierType"/></xsl:attribute>
                        <xsl:text>[</xsl:text><xsl:value-of select="$identifierType"/><xsl:text>: </xsl:text>
                        <xsl:value-of select="$identifier"/>
                        <xsl:text>]</xsl:text>
                    </xsl:element> <!-- </div> -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="div">
                        <xsl:attribute name="class"><xsl:value-of select="$providerIdentifierType"/></xsl:attribute>
                        <xsl:text>[Local Identifier: </xsl:text>
                        <xsl:value-of select="$identifier"/>
                        <xsl:text>]</xsl:text>
                    </xsl:element> <!-- </div> -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="substring-after-last-occurance">
        <xsl:param name="string"/>
        <xsl:param name="argument"/>
        
        <xsl:if test="$string and
                      string-length($string) &gt; 0 and
                      $argument and
                      string-length($argument) &gt; 0">
            <xsl:choose>
                <xsl:when test="contains($string, $argument)">
                    <xsl:call-template name="substring-after-last-occurance">
                        <xsl:with-param name="string" select="substring-after($string, $argument)"/>
                        <xsl:with-param name="argument" select="$argument"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$string"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getHL7V2Table0203IdentifierCodeDescription">
        <xsl:param name="code"/>
        
        <xsl:choose>
            <xsl:when test="$code='MR'">
                <xsl:text>MRN/URN</xsl:text>
            </xsl:when>
            <xsl:when test="$code='FI'">
                <xsl:text>Facility Identifier</xsl:text>
            </xsl:when>
            <xsl:when test="$code='SR'">
                <xsl:text>State Identifier</xsl:text>
            </xsl:when>
            <xsl:when test="$code='LR'">
                <xsl:text>Local Identifier</xsl:text>
            </xsl:when>
            <xsl:when test="$code='PRN'">
                <xsl:text>Provider Number</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
   
    <xsl:template name="toUpperCase">
        <xsl:param name="data"/>
        
        <xsl:if test="$data">
            <xsl:value-of select="translate($data,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getCodedAge">
        <xsl:param name="ageValue"></xsl:param>
        <xsl:param name="ageUcumUnitCode"/>
        
        <xsl:variable name="ucumUnitName">
            <xsl:call-template name="ucumUnitCodeToUnitNameShortForm">
                <xsl:with-param name="ucumUnit" select="$ageUcumUnitCode"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:if test="($ageValue = 0 or $ageValue &gt; 0) and 
                      (string-length($ucumUnitName) &gt; 0)">
            <xsl:value-of select="concat($ageValue, $ucumUnitName)"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="getDuration">
        <xsl:param name="value"></xsl:param>
        <xsl:param name="ucumUnitCode"/>
        
        <xsl:variable name="ucumUnitName">
            <xsl:call-template name="ucumUnitCodeToUnitName">
                <xsl:with-param name="ucumUnit" select="$ucumUnitCode"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:if test="($value = 0 or $value &gt; 0) and 
            (string-length($ucumUnitName) &gt; 0)">
            <xsl:value-of select="concat($value, ' ', $ucumUnitName)"/>
        </xsl:if>
    </xsl:template>
   
   <xsl:template name="getAttachment">
   <xsl:param name="value"></xsl:param>
   <xsl:param name="attachmentLink"></xsl:param>
             <xsl:element name="div">					
					   <xsl:attribute name="id"><xsl:value-of select="$value"/></xsl:attribute>
								 <xsl:attribute name="class">modal fade</xsl:attribute>
								 <xsl:attribute name="role">dialog</xsl:attribute>
								 <xsl:attribute name="tabindex">-1</xsl:attribute>
							         <xsl:element name="div">
									     <xsl:attribute name="class">modal-dialog modal-lg</xsl:attribute>
										 <xsl:element name="div">
										     <xsl:attribute name="class">modal-content</xsl:attribute>
											 <xsl:element name="div">
										        <xsl:attribute name="class">modal-header</xsl:attribute>
												<!--  <xsl:element name="button">
							                    <xsl:attribute name="type">button</xsl:attribute>
							                    <xsl:attribute name="class">close</xsl:attribute>
							                    <xsl:attribute name="data-dismiss">modal</xsl:attribute>
												x
												</xsl:element> -->
												<xsl:element name="h2">
												<xsl:attribute name="class">modal-title</xsl:attribute>
												PDF Viewer
												</xsl:element>
											</xsl:element>
											<xsl:element name="div">
											<xsl:attribute name="class">modal-body</xsl:attribute>
											                        <xsl:call-template name="addID">
                            <xsl:with-param name="element" select="."/>
                        </xsl:call-template>
						<xsl:element name="object">
						<xsl:attribute name="data"><xsl:value-of select="$attachmentLink"/></xsl:attribute>
													 <xsl:attribute name="width">100%</xsl:attribute>
													 <xsl:attribute name="height">900px</xsl:attribute>
											   <xsl:element name="embed">
											         <xsl:attribute name="src"><xsl:value-of select="$attachmentLink"/></xsl:attribute>
													 <xsl:attribute name="frameborder">0</xsl:attribute>
													 <xsl:attribute name="width">100%</xsl:attribute>
													 <xsl:attribute name="height">900px</xsl:attribute>
											    </xsl:element>
												</xsl:element>
												
												<xsl:element name="div">
											         <xsl:attribute name="class">modal-footer</xsl:attribute>
													 <xsl:element name="button">
													 <xsl:attribute name="type">button</xsl:attribute>
							                         <xsl:attribute name="class">close btn btn--secondary internal-link internal-link--mod</xsl:attribute>
							                         <xsl:attribute name="data-dismiss">modal</xsl:attribute>
                                                      Close
													 </xsl:element>
											    </xsl:element>
											</xsl:element>
										</xsl:element>
									</xsl:element>	
</xsl:element>																
								</xsl:template>	
    <xsl:template name="calculateAge">
        <xsl:param name="birthDate"/>
        <xsl:param name="docDate"/>
        
        <xsl:variable name="birthYear" select="substring($birthDate,1,4)"/>
        <xsl:variable name="birthMonth" select="substring($birthDate,5,2)"/>
        <xsl:variable name="birthDay" select="substring($birthDate,7,2)"/>
        <xsl:variable name="currentYear" select="substring($docDate,1,4)"/>
        <xsl:variable name="currentMonth" select="substring($docDate,5,2)"/>
        <xsl:variable name="currentDay" select="substring($docDate,7,2)"/>
        
        <xsl:variable name="startAge" select="$currentYear - $birthYear"/>
        <xsl:choose>
            <xsl:when test="$currentMonth &lt; $birthMonth">
                <xsl:variable name="age" select="$startAge - 1"/>
                <xsl:choose>
                    <xsl:when test="$age &lt; 2">
                        <xsl:call-template name="calculateDaysWeeksMonths">
                            <xsl:with-param name="birthDate">
                                <xsl:value-of select="$birthDate"/>
                            </xsl:with-param>
                            <xsl:with-param name="docDate">
                                <xsl:value-of select="$docDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$age"/>
                        <xsl:text> years</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$currentMonth = $birthMonth">
                <xsl:choose>
                    <xsl:when test="$currentDay &lt; $birthDay">
                        <xsl:variable name="age" select="$startAge - 1"/>
                        <xsl:choose>
                            <xsl:when test="$age &lt; 2">
                                <xsl:call-template name="calculateDaysWeeksMonths">
                                    <xsl:with-param name="birthDate">
                                        <xsl:value-of select="$birthDate"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="docDate">
                                        <xsl:value-of select="$docDate"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$age"/>
                                <xsl:text> years</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="age" select="$startAge"/>
                        <xsl:choose>
                            <xsl:when test="$age &lt; 2">
                                <xsl:call-template name="calculateDaysWeeksMonths">
                                    <xsl:with-param name="birthDate">
                                        <xsl:value-of select="$birthDate"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="docDate">
                                        <xsl:value-of select="$docDate"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$age"/>
                                <xsl:text> years</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                    
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="age" select="$startAge"/>
                <xsl:choose>
                    <xsl:when test="$age &lt; 2">
                        <xsl:call-template name="calculateDaysWeeksMonths">
                            <xsl:with-param name="birthDate">
                                <xsl:value-of select="$birthDate"/>
                            </xsl:with-param>
                            <xsl:with-param name="docDate">
                                <xsl:value-of select="$docDate"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$age"/>
                        <xsl:text> years</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="calculateDaysWeeksMonths">
        <xsl:param name="birthDate"/>
        <xsl:param name="docDate"/>
        
        <xsl:variable name="birthYear" select="substring($birthDate,1,4)"/>
        <xsl:variable name="birthMonth" select="substring($birthDate,5,2)"/>
        <xsl:variable name="birthDay" select="substring($birthDate,7,2)"/>
        <xsl:variable name="currentYear" select="substring($docDate,1,4)"/>
        <xsl:variable name="currentMonth" select="substring($docDate,5,2)"/>
        <xsl:variable name="currentDay" select="substring($docDate,7,2)"/>
        <xsl:variable name="birthMonthDays">
            <xsl:call-template name="daysInMonth">
                <xsl:with-param name="month">
                    <xsl:value-of select="$birthMonth"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="startAge" select="$currentYear - $birthYear"/>
        <xsl:choose>
            <!-- SAME YEAR -->
            <xsl:when test="$currentYear = $birthYear">
                <xsl:choose>
                    <!-- SAME MONTH -->
                    <xsl:when test="($currentMonth = $birthMonth)">
                        <xsl:choose>
                            <xsl:when test="($currentDay - $birthDay) &lt; 7">
                                <xsl:value-of select="$currentDay - $birthDay"/>
                                <xsl:text>d</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="floor(($currentDay - $birthDay) div 7)"/>
                                <xsl:text>w</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- DIFF MONTH -->
                    <xsl:otherwise>
                        <xsl:variable name="numDays" select="($birthMonthDays - $birthDay) + $currentDay"/>
                        <xsl:choose>
                            <xsl:when test="(($currentMonth - $birthMonth) = 1) and numDays &lt; 7">
                                <xsl:value-of select="$numDays"/>
                                <xsl:text>d</xsl:text>
                            </xsl:when>
                            <xsl:when test="($currentMonth - $birthMonth) = 1">
                                <xsl:value-of select="floor($numDays div 7)"/>
                                <xsl:text>w</xsl:text>
                            </xsl:when>
                            <xsl:when test="($currentMonth - $birthMonth) = 2">
                                <!-- Get days of middle month -->
                                <xsl:variable name="middleMonthDays">
                                    <xsl:call-template name="daysInMonth">
                                        <xsl:with-param name="month">
                                            <xsl:value-of select="$birthMonth + 1"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:variable name="totalNumDays" select="$numDays + $middleMonthDays"/>
                                <xsl:choose>
                                    <xsl:when test="$totalNumDays &lt; 56">
                                        <xsl:value-of select="floor($totalNumDays div 7)"/> 
                                        <xsl:text>w</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>2m</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$currentMonth - $birthMonth"/>
                                <xsl:text>m</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>                    
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- DIFF YEAR -->
            <xsl:otherwise>
                <xsl:variable name="totalMonthDiff" select="(($currentYear - $birthYear) * 12) + $currentMonth - $birthMonth"/>
                <xsl:variable name="numDays" select="($birthMonthDays - $birthDay) + $currentDay"/>
                <xsl:choose>
                    <xsl:when test="($totalMonthDiff = 1) and ($numDays &lt; 7)">
                        <xsl:value-of select="$numDays"/>
                        <xsl:text>d</xsl:text>
                    </xsl:when>
                    <xsl:when test="($totalMonthDiff = 1)">
                        <xsl:value-of select="floor($numDays div 7)"/>
                        <xsl:text>w</xsl:text>
                    </xsl:when>
                    <xsl:when test="($totalMonthDiff = 2)">
                        <!-- Get days of middle month. If Dec, this increment to 13, will default to 31 days which is Jan -->
                        <xsl:variable name="middleMonthDays">
                            <xsl:call-template name="daysInMonth">
                                <xsl:with-param name="month">
                                    <xsl:value-of select="$birthMonth + 1"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="totalNumDays" select="$numDays + $middleMonthDays"/>
                        <xsl:choose>
                            <xsl:when test="$totalNumDays &lt; 56">
                                <xsl:value-of select="floor($totalNumDays div 7)"/> 
                                <xsl:text>w</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>2m</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$currentDay &lt; $birthDay">
                                <xsl:value-of select="$totalMonthDiff - 1"/>
                                <xsl:text>m</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$totalMonthDiff"/>
                                <xsl:text>m</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="daysInMonth">
        <xsl:param name="month"/>
        <xsl:choose>
            <xsl:when test="$month = '02' or month = 2">
                <xsl:value-of select="28"/>
            </xsl:when>
            <xsl:when test="$month = '04' or $month = '06' or $month = '09' or $month = '11' or $month = 4 or $month = 6 or $month = 9 or $month = 11">
                <xsl:value-of select="30"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="31"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="formatHI">
        <xsl:param name="hiValue"/>
        <xsl:if test="$hiValue">
            <xsl:variable name="identifier">
                <xsl:call-template name="trim">
                    <xsl:with-param name="string">
                        <xsl:choose>
                            <xsl:when test="string-length($hiValue) &gt; 16">
                                <xsl:value-of select="substring($hiValue, string-length($hiValue)-15, string-length($hiValue))"/>
                            </xsl:when>
                            <xsl:when test="string-length($hiValue) = 16">
                                <xsl:value-of select="$hiValue"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="string-length($identifier)=16">
                <xsl:value-of select="substring($identifier,1,4)"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring($identifier,5,4)"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring($identifier,9,4)"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring($identifier,13,4)"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="printNBSPs">
        <xsl:param name="number"/>
        
        <xsl:if test="$number &gt; 0">
            <xsl:element name="span">
                <xsl:attribute name="class">nbspSpan</xsl:attribute>
            </xsl:element>
            <xsl:call-template name="printNBSPs">
                <xsl:with-param name="number" select="$number - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="lTrim">
      <xsl:param name="string"/>
      <xsl:choose>
         <xsl:when test="substring($string, 1, 1) = ''">
            <xsl:value-of select="$string"/>
         </xsl:when>
         <xsl:when test="normalize-space(substring($string, 1, 1)) = ''">
            <xsl:call-template name="lTrim">
               <xsl:with-param name="string" select="substring($string, 2)"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$string"/>
         </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
   
    <xsl:template name="rTrim">
      <xsl:param name="string"/>
      <xsl:choose>
         <xsl:when test="substring($string, 1, 1) = ''">
            <xsl:value-of select="$string"/>
         </xsl:when>
         <xsl:when test="normalize-space(substring($string, string-length($string))) = ''">
            <xsl:call-template name="rTrim">
               <xsl:with-param name="string" select="substring($string, 1, string-length($string) - 1)"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$string"/>
         </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
      
    <xsl:template name="trim">
      <xsl:param name="string"/>
      <xsl:call-template name="rTrim">
         <xsl:with-param name="string">
            <xsl:call-template name="lTrim">
               <xsl:with-param name="string" select="$string"/>
            </xsl:call-template>
         </xsl:with-param>
      </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="lastIndexOf">
        <xsl:param name="string" />
        <xsl:param name="char" />
        <xsl:choose>
            <!-- if the string contains the character... -->
            <xsl:when test="contains($string, $char)">
                <!-- call the template recursively... -->
                <xsl:call-template name="lastIndexOf">
                    <!-- with the string being the string after the character
                    -->
                    <xsl:with-param name="string"
                        select="substring-after($string, $char)" />
                    <!-- and the character being the same as before -->
                    <xsl:with-param name="char" select="$char" />
                </xsl:call-template>
            </xsl:when>
            <!-- otherwise, return the value of the string -->
            <xsl:otherwise><xsl:value-of select="$string" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getDocumentIdentifier">
        <xsl:param name="iiVariable"/>
        <xsl:choose>
            <xsl:when test="string-length($iiVariable/@root) &gt; 0 and string-length($iiVariable/@extension) &gt; 0 and string-length($iiVariable/@assigningAuthorityName) &gt; 0">
                <xsl:value-of select="$iiVariable/@extension"/><xsl:text> (</xsl:text><xsl:value-of select="$iiVariable/@assigningAuthorityName"/><xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:when test="string-length($iiVariable/@root) &gt; 0 and string-length($iiVariable/@extension) &gt; 0">
                <xsl:value-of select="$iiVariable/@extension"/><xsl:text> (</xsl:text><xsl:value-of select="$iiVariable/@root"/><xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:when test="string-length($iiVariable/@root) &gt; 0 and string-length($iiVariable/@assigningAuthorityName) &gt; 0">
                <xsl:value-of select="$iiVariable/@root"/><xsl:text> (</xsl:text><xsl:value-of select="$iiVariable/@assigningAuthorityName"/><xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:when test="string-length($iiVariable/@root) &gt; 0">
                <xsl:value-of select="$iiVariable/@root"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="addID">
        <xsl:param name="element"/>
        <xsl:if test="$element/@ID and
                      string-length($element/@ID) &gt; 0">
            <xsl:element name="div">
                <xsl:attribute name="id"><xsl:value-of select="$element/@ID"/></xsl:attribute>
                <xsl:attribute name="name"><xsl:value-of select="$element/@ID"/></xsl:attribute>
                <xsl:attribute name="class">positionRelative</xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
        <xsl:template name="containsJavaScript">
        <xsl:param name="reference"/>
        <xsl:variable name="upperCaseReference">
            <xsl:call-template name="toUpperCase"><xsl:with-param name="data" select="$reference"/></xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($upperCaseReference, 'JAVASCRIPT') or contains($upperCaseReference, 'JSCRIPT')">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--================================================================================================================================================================================-->
    <!-- [END] UTILITY TEMPLATES -->
</xsl:stylesheet>
